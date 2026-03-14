import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/medical_history_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/patient_personal_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_info_form.dart';
import 'package:mediconnect/common/auth/presentation/pages/pharmacist_infomation_capture/pharmacy_verification_form.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class InformationCapturePage extends StatefulWidget {
  const InformationCapturePage({super.key, required this.role});

  final UserType role;

  @override
  State<InformationCapturePage> createState() => _InformationCapturePageState();
}

class _InformationCapturePageState extends State<InformationCapturePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _firstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormKey = GlobalKey<FormState>();

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

  void _goToNextTab() {
    if (_tabController.index == 0 &&
        _firstFormKey.currentState?.validate() == true) {
      _tabController.animateTo(1);
    }
  }

  void _completeRegistration() {
    if (_secondFormKey.currentState?.validate() != true) return;
    final isPatient = widget.role == UserType.patient;
    final hasPatientData =
        patientInfoInput != null && medicalHistoryInput != null;
    final hasPharmacyData =
        pharmacyInfoInput != null && pharmacyVerificationInput != null;

    if ((isPatient && hasPatientData) || (!isPatient && hasPharmacyData)) {
      // TODO: hook into persistence/API with the collected inputs.
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBack: () => context.pop(),
      scaffoldActions: [
        TextButton(
          onPressed: () {
            context.go('/welcome');
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
          color: isActive ? color : color.withOpacity(0.3),
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
        formKey: _firstFormKey,
        onSubmit: (input) {
          patientInfoInput = input;
          _goToNextTab();
        },
      );
    } else {
      return PharmacyInfoForm(
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

// Pharmacist placeholder forms
class PharmacistPersonalInfoForm extends StatelessWidget {
  const PharmacistPersonalInfoForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            'Pharmacist Personal Information',
            style: TextStyle(
              fontSize: context.figmaFontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.figmaHeight(32)),
          Text(
            'Pharmacist registration form will be implemented here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.figmaFontSize(14),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: context.figmaHeight(32)),
          ElevatedButton(onPressed: onSubmit, child: const Text('Next')),
        ],
      ),
    );
  }
}
