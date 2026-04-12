import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';

class SecurityCodeVerificationPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const SecurityCodeVerificationPage({super.key, required this.data});

  @override
  ConsumerState<SecurityCodeVerificationPage> createState() => _SecurityCodeVerificationPageState();
}

class _SecurityCodeVerificationPageState extends ConsumerState<SecurityCodeVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final title = widget.data['title'] as String? ?? 'Enter Confirmation Code';
    final subtitle = widget.data['subtitle'] as String? ?? '';
    final nextRoute = widget.data['nextRoute'] as String;
    final successData = widget.data['successData'] as Map<String, dynamic>?;

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text(''),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
            ),
            SizedBox(height: context.figmaHeight(8)),
            Text(
              subtitle,
              style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
            ),
            SizedBox(height: context.figmaHeight(32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildOtpBox(index, theme)),
            ),
            SizedBox(height: context.figmaHeight(24)),
            Center(
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'You can resend code in ',
                          style: AppTextStyles.interP14R.copyWith(color: theme.neutral.tertiaryText),
                        ),
                        TextSpan(
                          text: '56',
                          style: AppTextStyles.interP14R.copyWith(color: theme.support.red, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' seconds',
                          style: AppTextStyles.interP14R.copyWith(color: theme.neutral.tertiaryText),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.figmaHeight(8)),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Resend code',
                      style: AppTextStyles.interP14M.copyWith(color: theme.support.red),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            KElevatedButton(
              onPressed: () {
                context.push(nextRoute, extra: successData);
              },
              child: const Text('Next'),
            ),
            SizedBox(height: context.figmaHeight(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index, AppColorsTheme theme) {
    return Container(
      width: context.figmaWidth(48),
      height: context.figmaHeight(56),
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.interP18M,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
