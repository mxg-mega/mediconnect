import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/presentation/pages/information_capture_page.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/router/k_navigate.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class SetupFinalizationPage extends ConsumerStatefulWidget {
  const SetupFinalizationPage({super.key});

  @override
  ConsumerState<SetupFinalizationPage> createState() =>
      _SetupFinalizationPageState();
}

class _SetupFinalizationPageState extends ConsumerState<SetupFinalizationPage> {
  String? _selectedAccountType;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 300), () {
      ref.read(appScaffoldProvider.notifier).setFlow(AppFlow.signup);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final appScaffoldNotifier = ref.read(appScaffoldProvider.notifier);
    const String patientRole = 'patient';
    const String pharmacistRole = 'pharmacist';

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('Finalize Your Account Setup'),
              Text(
                'Please select your account type: Patient or Pharmacist.',
                textAlign: TextAlign.center,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedAccountType == patientRole
                        ? theme.patient.bg
                        : Colors.grey.shade300,
                    width: _selectedAccountType == patientRole ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: _selectedAccountType == patientRole
                      ? theme.patient.bgTint
                      : null,
                ),
                child: ListTile(
                  leading: SvgPicture.asset(
                    fit: BoxFit.cover,
                    'assets/svg/patient-medication.svg',
                  ),
                  title: Text('Patient'),
                  subtitle: const Text(
                    'I want to browse medications & manage my health.',
                  ),
                  onTap: () {
                    setState(() {
                      _selectedAccountType = patientRole;
                    });
                    // Update the role in AppScaffold provider
                    appScaffoldNotifier.setPreviewRole(UserRole.patient);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedAccountType == pharmacistRole
                        ? theme.pharmacist.bg
                        : Colors.grey.shade300,
                    width: _selectedAccountType == pharmacistRole ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: _selectedAccountType == pharmacistRole
                      ? theme.pharmacist.bgTint
                      : null,
                ),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/svg/pharmacist-stethoscope.svg',
                    fit: BoxFit.cover,
                  ),
                  title: Text('Pharmacist'),
                  subtitle: const Text(
                    'I manage prescriptions, inventory & patients.',
                  ),
                  onTap: () {
                    setState(() {
                      _selectedAccountType = pharmacistRole;
                    });
                    // Update the role in AppScaffold provider
                    appScaffoldNotifier.setPreviewRole(UserRole.pharmacist);
                  },
                ),
              ),
              KElevatedButton(
                color: _selectedAccountType == patientRole
                    ? theme.patient.bg
                    : theme.pharmacist.bg,
                onPressed: _selectedAccountType != null
                    ? () {
                        // Finalize setup logic here
                        print('Selected account type: $_selectedAccountType');
                        // Role is already updated in AppScaffold provider

                        // Navigate to the next onboarding page based on role
                        var page = InformationCapturePage(
                          role: _selectedAccountType == patientRole
                              ? UserType.patient
                              : UserType.pharmacist,
                        );
                        
                        navigateToPage(context, page);
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Need both roles? Add another account later.',
                  style: AppTextStyles.interP14M.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
                TextSpan(
                  text: ' Learn More',
                  style: AppTextStyles.interP14M.copyWith(
                    color: theme.support.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
