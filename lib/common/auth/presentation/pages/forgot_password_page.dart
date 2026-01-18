import 'package:flutter/material.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return AppScaffold(
      onBack: () {},
      body: Column(
        children: [
          Text('Reset Your Password'),
          Text('Email'),
          TextField(
            decoration: InputDecoration(hintText: 'Your Email'),
            controller: emailController,
          ),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, context.figmaHeight(50)),
            ),
            child: const Text('Send Code'),
          ),
        ],
      ),
    );
  }
}
