import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/medical_history_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/patient_personal_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_verification_form.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';

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
  final GlobalKey<FormState> _firstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormKey = GlobalKey<FormState>();

  final _patientFormKey = GlobalKey<PatientPersonalInfoFormState>();
  final _pharmacyFormKey = GlobalKey<PharmacyInfoFormState>();

  MedicalHistoryInput? medicalHistoryInput;
  PatientInfoInput? patientInfoInput;
  PharmacyInfoInput? pharmacyInfoInput;
  PharmacyVerificationInput? pharmacyVerificationInput;

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

  Future<void> _completeRegistration() async {
    if (_secondFormKey.currentState?.validate() != true) return;

    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

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
    } else if (widget.role == UserType.pharmacist &&
        pharmacyInfoInput != null) {
      final usecase = ref.read(createPharmacyUseCaseProvider);

      final pharmacy = Pharmacy(
        id: '',
        name: pharmacyInfoInput!.pharmacyName,
        address: pharmacyInfoInput!.address,
        phoneNumber: pharmacyInfoInput!.contactNumber,
        email: pharmacyInfoInput!.email,
        businessEmail: pharmacyInfoInput!.email,
        type: pharmacyInfoInput!.type,
        description: pharmacyInfoInput!.description,
        operatingHours: const [], // Can implement proper parsing if needed
        location: const GeoLocation(latitude: 0.0, longitude: 0.0, address: ''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await usecase(pharmacy, currentUser.id, 'owner');
    }

    try {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.role);
    return AppScaffold(
      onBack: () => context.pop(),
      scaffoldActions: [
        TextButton(
          onPressed: _quickFill,
          child: Text(
            'Quick Fill',
            style: TextStyle(color: AppTheme.colors(context).support.blue),
          ),
        ),
        TextButton(
          onPressed: () async {
            final currentUser = ref.read(authProvider).user;
            if (currentUser != null) {
              await ref
                  .read(authProvider.notifier)
                  .updateProfileInfo(
                    updatedUser: currentUser.copyWith(
                      userType: widget.role,
                      isProfileComplete: true,
                    ),
                  );
            }
            if (context.mounted) {
              context.go('/welcome');
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.colors(context).support.red,
          ),
          child: const Text('Skip'),
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
        onSubmit: (input) {
          medicalHistoryInput = input;
          _completeRegistration();
        },
      );
    } else {
      return PharmacistVerificationForm(
        formKey: _secondFormKey,
        onSubmit: (input) {
          pharmacyVerificationInput = input;
          _completeRegistration();
        },
      );
    }
  }
}
