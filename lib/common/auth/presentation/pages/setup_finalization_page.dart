import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

class SetupFinalizationPage extends ConsumerStatefulWidget {
  const SetupFinalizationPage({super.key});

  @override
  ConsumerState<SetupFinalizationPage> createState() =>
      _SetupFinalizationPageState();
}

class _SetupFinalizationPageState extends ConsumerState<SetupFinalizationPage> {
  String? _selectedAccountType;
  bool _isLoading = false;

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

    print(_selectedAccountType);
    print(ref.read(currentUserProvider)?.userType);
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text('Finalize Your Account Setup'),
              const Text(
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
                  title: const Text('Patient'),
                  subtitle: const Text(
                    'I want to browse medications & manage my health.',
                  ),
                  onTap: () {
                    setState(() {
                      _selectedAccountType = patientRole;
                    });
                    // Update the role in AppScaffold provider
                    appScaffoldNotifier.setPreviewRole(UserType.patient);
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
                  title: const Text('Pharmacist'),
                  subtitle: const Text(
                    'I manage prescriptions, inventory & patients.',
                  ),
                  onTap: () {
                    setState(() {
                      _selectedAccountType = pharmacistRole;
                    });
                    // Update the role in AppScaffold provider
                    appScaffoldNotifier.setPreviewRole(UserType.pharmacist);
                  },
                ),
              ),
              KElevatedButton(
                backgroundColor: _selectedAccountType == patientRole
                    ? theme.patient.bg
                    : theme.pharmacist.bg,
                onPressed: _selectedAccountType != null && !_isLoading
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final userType = _selectedAccountType == patientRole
                            ? UserType.patient
                            : UserType.pharmacist;

                        try {
                          final currentUser = ref.read(currentUserProvider);
                          if (currentUser != null) {
                            final updatedUser = currentUser.copyWith(
                              userType: userType,
                            );
                            await ref
                                .read(authProvider.notifier)
                                .updateProfileInfo(updatedUser: updatedUser);
                          }

                          if (!mounted) return;

                          setState(() {
                            _isLoading = false;
                          });

                          print("userType: " + userType.toString());
                          context.push(
                            AppRoutes.informationCapture,
                            extra: userType,
                          );
                        } catch (e) {
                          if (!mounted) return;
                          setState(() {
                            _isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update role: $e'),
                            ),
                          );
                        }
                      }
                    : null,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Continue'),
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
