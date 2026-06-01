import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/medical_history_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/patient_personal_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_verification_form.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_provider.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/utils/pharmacy_verification_docs.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/services/document_upload_service.dart';
import 'package:mediconnect/core/utils/document_url_utils.dart';

class InformationCapturePage extends ConsumerStatefulWidget {
  const InformationCapturePage({super.key, required this.role});

  final UserType role;

  @override
  ConsumerState<InformationCapturePage> createState() =>
      _InformationCapturePageState();
}

class _InformationCapturePageState extends ConsumerState<InformationCapturePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  final GlobalKey<FormState> _firstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormKey = GlobalKey<FormState>();

  final _patientFormKey = GlobalKey<PatientPersonalInfoFormState>();
  final _pharmacyFormKey = GlobalKey<PharmacyInfoFormState>();

  MedicalHistoryInput? medicalHistoryInput;
  Map<String, PlatformFile?>? patientMedicalFiles;
  PatientInfoInput? patientInfoInput;
  PharmacyInfoInput? pharmacyInfoInput;
  PharmacyVerificationInput? pharmacyVerificationInput;
  Map<String, PlatformFile?>? pharmacyVerificationFiles;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _quickFill() {
    if (widget.role == UserType.patient) {
      _patientFormKey.currentState?.quickFill();
    } else {
      _pharmacyFormKey.currentState?.quickFill();
    }
  }

  void _goToNextTab() {
    if (_tabController.index == 0 &&
        _firstFormKey.currentState?.validate() == true) {
      _tabController.animateTo(1);
    }
  }

  Future<({double lat, double lng})> _resolveLocation() async {
    double lat = 0.0;
    double lng = 0.0;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );
          lat = position.latitude;
          lng = position.longitude;
        }
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }

    return (lat: lat, lng: lng);
  }

  Pharmacy _buildPharmacyFromInput({
    required PharmacyInfoInput input,
    required double lat,
    required double lng,
    required bool isRegistrationComplete,
  }) {
    return Pharmacy(
      id: '',
      name: input.pharmacyName,
      address: input.address,
      phoneNumber: input.contactNumber,
      email: input.email,
      businessEmail: input.email,
      type: input.type,
      description: input.description,
      operatingHours: const [],
      location: GeoLocation(
        latitude: lat,
        longitude: lng,
        address: input.address,
      ),
      isRegistrationComplete: isRegistrationComplete,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Pharmacy _buildPlaceholderPharmacy(UserModel user) {
    final firstName = user.firstName.trim();
    final name = firstName.isNotEmpty ? "$firstName's Pharmacy" : 'My Pharmacy';

    return Pharmacy(
      id: '',
      name: name,
      address: 'Address pending',
      phoneNumber: user.phoneNumber ?? '',
      email: user.email,
      businessEmail: user.email,
      type: PharmacyType.retail,
      description: '',
      operatingHours: const [],
      location: const GeoLocation(
        latitude: 0.0,
        longitude: 0.0,
        address: 'Address pending',
      ),
      isRegistrationComplete: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _invalidatePharmacyProviders() async {
    ref.invalidate(currentPharmacyIdProvider);
    ref.invalidate(currentPharmacyProvider);
    ref.invalidate(currentPharmacyStatusProvider);
  }

  Future<Pharmacy> _uploadVerificationDocuments({
    required Pharmacy pharmacy,
    required Map<String, PlatformFile?> files,
  }) async {
    final uploadService = ref.read(documentUploadServiceProvider);
    final basePath = 'pharmacies/${pharmacy.id}/verification';

    Future<String?> uploadKey(String key, String folder) async {
      final file = files[key];
      if (file == null) return null;
      return uploadService.uploadPlatformFile(
        file: file,
        storagePath: '$basePath/$folder',
      );
    }

    final frontalUrl = await uploadKey('frontal', 'frontal');
    final licenseUrl = await uploadKey('license', 'license');
    final businessRegUrl =
        await uploadKey('business_reg', 'business_registration');
    final pcnCertUrl = await uploadKey('pcn_cert', 'pcn_certificate');
    final addressProofUrl = await uploadKey('address_proof', 'address_proof');
    final additionalUrl = await uploadKey('additional_cert', 'additional');

    var updated = pharmacy.copyWith(
      pcnRegistrationNumber: pharmacyVerificationInput?.pcnIdNumber ??
          pharmacy.pcnRegistrationNumber,
      pcnAgency:
          pharmacyVerificationInput?.agencySelection ?? pharmacy.pcnAgency,
      updatedAt: DateTime.now(),
    );

    void applyUpload(String? url, String slotKey, String fileKey) {
      if (url == null) return;
      final file = files[fileKey];
      final contentType = file != null
          ? DocumentUrlUtils.contentTypeFromFileName(file.name)
          : 'application/octet-stream';
      updated = applyVerificationSlotUpload(
        pharmacy: updated,
        slotKey: slotKey,
        downloadUrl: url,
        contentType: contentType,
      );
    }

    applyUpload(frontalUrl, PharmacyVerificationSlotKeys.frontal, 'frontal');
    applyUpload(licenseUrl, PharmacyVerificationSlotKeys.license, 'license');
    applyUpload(
      businessRegUrl,
      PharmacyVerificationSlotKeys.businessRegistration,
      'business_reg',
    );
    applyUpload(
      pcnCertUrl,
      PharmacyVerificationSlotKeys.pcnCertificate,
      'pcn_cert',
    );
    applyUpload(
      addressProofUrl,
      PharmacyVerificationSlotKeys.addressProof,
      'address_proof',
    );
    applyUpload(
      additionalUrl,
      PharmacyVerificationSlotKeys.additional,
      'additional_cert',
    );

    await ref.read(updatePharmacyInfoUseCaseProvider)(updated);
    return updated;
  }

  Future<void> _savePatientMedicalHistory({
    required String patientId,
    required MedicalHistoryInput input,
    Map<String, PlatformFile?>? files,
  }) async {
    final uploadService = ref.read(documentUploadServiceProvider);
    final basePath = 'users/$patientId/medical_documents';

    Future<String?> uploadKey(String key, String folder) async {
      final file = files?[key];
      if (file == null) return null;
      return uploadService.uploadPlatformFile(
        file: file,
        storagePath: '$basePath/$folder',
      );
    }

    String? medicalRecordUrl;
    String? insuranceCardUrl;
    try {
      medicalRecordUrl = await uploadKey('medical_record', 'medical_record');
      insuranceCardUrl = await uploadKey('insurance_card', 'insurance_card');
    } on DocumentUploadException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document upload failed: ${e.message}')),
        );
      }
      rethrow;
    }

    final history = input.toModel().copyWith(
      id: patientId,
      patientId: patientId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final payload = history.toJson()
      ..['documents'] = {
        if (medicalRecordUrl != null) 'medical_record_url': medicalRecordUrl,
        if (insuranceCardUrl != null) 'insurance_card_url': insuranceCardUrl,
      };

    await FirebaseFirestore.instance
        .collection('medical_history')
        .doc(patientId)
        .set(payload, SetOptions(merge: true));
  }

  Future<Pharmacy> _createPharmacyForUser({
    required Pharmacy pharmacy,
    required String ownerUid,
  }) async {
    final usecase = ref.read(createPharmacyUseCaseProvider);
    return usecase(pharmacy, ownerUid, 'owner');
  }

  Future<void> _skipRegistration() async {
    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.role == UserType.pharmacist) {
        await _createPharmacyForUser(
          pharmacy: _buildPlaceholderPharmacy(currentUser),
          ownerUid: currentUser.id,
        );
        await _invalidatePharmacyProviders();
      }

      await ref.read(authProvider.notifier).updateProfileInfo(
            updatedUser: currentUser.copyWith(
              userType: widget.role,
              isProfileComplete: true,
            ),
          );

      if (mounted) {
        context.go('/welcome');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to skip registration: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _completeRegistration() async {
    if (_secondFormKey.currentState?.validate() != true) return;

    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel updatedUser = currentUser.copyWith(
        userType: widget.role,
        isProfileComplete: true,
      );

      if (widget.role == UserType.patient && patientInfoInput != null) {
        final names = patientInfoInput!.fullName.split(' ');
        final fn = names.isNotEmpty ? names.first : null;
        final ln = names.length > 1 ? names.sublist(1).join(' ') : null;

        updatedUser = updatedUser.copyWith(
          firstName: fn?.isNotEmpty == true ? fn : null,
          lastName: ln?.isNotEmpty == true ? ln : null,
          phoneNumber: patientInfoInput!.phoneNumber.isNotEmpty
              ? patientInfoInput!.phoneNumber
              : null,
          address: patientInfoInput!.address.isNotEmpty
              ? patientInfoInput!.address
              : null,
          gender: patientInfoInput!.gender.isNotEmpty
              ? patientInfoInput!.gender
              : null,
          dateOfBirth: patientInfoInput!.dateOfBirth,
        );

        if (medicalHistoryInput != null) {
          final hasDocs = patientMedicalFiles != null &&
              patientMedicalFiles!.values.any((f) => f != null);
          try {
            await _savePatientMedicalHistory(
              patientId: currentUser.id,
              input: medicalHistoryInput!,
              files: hasDocs ? patientMedicalFiles : null,
            );
          } on DocumentUploadException {
            return;
          }
        }
      } else if (widget.role == UserType.pharmacist &&
          pharmacyInfoInput != null) {
        final location = await _resolveLocation();
        final pharmacy = _buildPharmacyFromInput(
          input: pharmacyInfoInput!,
          lat: location.lat,
          lng: location.lng,
          isRegistrationComplete: true,
        );

        var created = await _createPharmacyForUser(
          pharmacy: pharmacy,
          ownerUid: currentUser.id,
        );

        if (pharmacyVerificationFiles != null &&
            pharmacyVerificationFiles!.values.any((f) => f != null)) {
          try {
            created = await _uploadVerificationDocuments(
              pharmacy: created,
              files: pharmacyVerificationFiles!,
            );
          } on DocumentUploadException catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document upload failed: ${e.message}')),
              );
            }
          }
        }

        await _invalidatePharmacyProviders();
      }

      await ref
          .read(authProvider.notifier)
          .updateProfileInfo(updatedUser: updatedUser);
      if (mounted) {
        context.go('/welcome');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBack: () => context.pop(),
      scaffoldActions: [
        TextButton(
          onPressed: _isLoading ? null : _quickFill,
          child: Text(
            'Quick Fill',
            style: TextStyle(color: AppTheme.colors(context).support.blue),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _skipRegistration,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.colors(context).support.red,
          ),
          child: _isLoading
              ? SizedBox(
                  width: context.figmaWidth(16),
                  height: context.figmaWidth(16),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Skip'),
        ),
      ],
      body: Column(
        children: [
          // Tab indicators
          SizedBox(
            height: context.figmaHeight(8),
            child: Row(
              children: [
                _buildTabIndicator(0, 'Personal Info'),
                SizedBox(width: context.figmaWidth(8)),
                _buildTabIndicator(
                  1,
                  widget.role == UserType.patient
                      ? 'Medical History'
                      : 'Pharmacy Details',
                ),
              ],
            ),
          ),
          SizedBox(height: context.figmaHeight(24)),
          // Form content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                SingleChildScrollView(child: _buildFirstForm()),
                SingleChildScrollView(child: _buildSecondForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabIndicator(int index, String title) {
    final isActive = _tabController.index == index;
    final color = widget.role == UserType.patient
        ? AppTheme.colors(context).patient.bg
        : AppTheme.colors(context).pharmacist.bg;

    return Expanded(
      child: Container(
        height: context.figmaHeight(4),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(context.figmaWidth(2)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              fontSize: context.figmaFontSize(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstForm() {
    if (widget.role == UserType.patient) {
      return PatientPersonalInfoForm(
        key: _patientFormKey,
        formKey: _firstFormKey,
        onSubmit: (input) {
          patientInfoInput = input;
          _goToNextTab();
        },
      );
    } else {
      return PharmacyInfoForm(
        key: _pharmacyFormKey,
        formKey: _firstFormKey,
        onSubmit: (input) {
          pharmacyInfoInput = input;
          _goToNextTab();
        },
      );
    }
  }

  Widget _buildSecondForm() {
    if (widget.role == UserType.patient) {
      return MedicalHistoryForm(
        formKey: _secondFormKey,
        isLoading: _isLoading,
        onSubmit: (input, {required files}) {
          medicalHistoryInput = input;
          patientMedicalFiles = files;
          _completeRegistration();
        },
      );
    } else {
      return PharmacistVerificationForm(
        formKey: _secondFormKey,
        isLoading: _isLoading,
        onSubmit: (input, {required files}) {
          pharmacyVerificationInput = input;
          pharmacyVerificationFiles = files;
          _completeRegistration();
        },
      );
    }
  }
}
