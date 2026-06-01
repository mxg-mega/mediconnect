import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/code_input_field.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class CodeVerificationPage extends ConsumerStatefulWidget {
  const CodeVerificationPage({
    super.key,
    required this.nextPage,
    required this.email,
  });

  final Widget nextPage;
  final String email;

  @override
  ConsumerState<CodeVerificationPage> createState() =>
      _CodeVerificationPageState();
}

class _CodeVerificationPageState extends ConsumerState<CodeVerificationPage> {
  // ── State ────────────────────────────────────────────────────────────────
  String _currentCode = '';
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  // ── Countdown timer ───────────────────────────────────────────────────────
  static const _resendCooldownSeconds = 59;
  int _secondsRemaining = _resendCooldownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Timer helpers ─────────────────────────────────────────────────────────
  void _startTimer() {
    setState(() => _secondsRemaining = _resendCooldownSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        setState(() {});
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  bool get _canResend => _secondsRemaining <= 0;

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> _verifyOtp() async {
    if (_currentCode.length < 6 || _isVerifying) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).verifyEmailOtp(_currentCode);

      if (mounted) {
        final authState = ref.read(authProvider);

        // If the user is authenticated (e.g. signup flow), GoRouter's redirect logic
        // will automatically take over since the verificationStatus has changed to verified.
        // We only manually navigate if they are unauthenticated (e.g. forgot password flow).
        if (!authState.isAuthenticated) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextPage));
        }
      }
    } catch (e) {
      String message = e.toString();
      if (message.contains('OTP has expired')) {
        message = 'Your code has expired. Please request a new one.';
      } else if (message.contains('Invalid OTP code')) {
        message = 'Incorrect code. Please try again.';
      } else {
        message = 'Verification failed. Please try again.';
      }

      if (mounted) {
        setState(() => _errorMessage = message);
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).sendEmailVerification(widget.email);
      _startTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A new code has been sent to your email.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Failed to resend code. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final maskedEmail = _maskEmail(widget.email);

    return AppScaffold(
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Verification Code',
            style: AppTextStyles.inter32M.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.interP16R.copyWith(
                color: AppTheme.colors(context).neutral.tertiaryText,
              ),
              children: [
                const TextSpan(text: 'We sent a 6-digit code to '),
                TextSpan(
                  text: maskedEmail,
                  style: AppTextStyles.interP16R.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: '. Enter it below to verify your account.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // OTP Input
          CodeInputField(
            onCompleted: (code) {
              setState(() => _currentCode = code);
            },
          ),

          const SizedBox(height: 16),

          // Error message
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.support.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colors.support.red,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTextStyles.interP14R.copyWith(
                        color: colors.support.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Verify button
          KElevatedButton(
            onPressed: (_currentCode.length == 6 && !_isVerifying)
                ? _verifyOtp
                : null,
            child: _isVerifying
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verify Email'),
          ),

          const SizedBox(height: 24),

          // Resend section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_canResend) ...[
                Text(
                  'Resend code in ',
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.neutral.border,
                  ),
                ),
                Text(
                  '$_secondsRemaining s',
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.support.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                Text(
                  "Didn't receive a code? ",
                  style: AppTextStyles.interP14R.copyWith(
                    color: colors.neutral.border,
                  ),
                ),
                GestureDetector(
                  onTap: _resendCode,
                  child: _isResending
                      ? SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.support.red,
                          ),
                        )
                      : Text(
                          'Resend Code',
                          style: AppTextStyles.interP14R.copyWith(
                            color: colors.support.red,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.support.red,
                          ),
                        ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Masks the email for privacy: e.g. john@example.com → j***@example.com
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;
    final name = parts[0];
    final domain = parts[1];
    final masked = '${name[0]}${'*' * (name.length - 1)}@$domain';
    return masked;
  }
}
