import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediconnect/common/auth/presentation/widgets/otp_input_field.dart';

class CodeInputField extends StatefulWidget {
  final void Function(String code) onCompleted;

  const CodeInputField({super.key, required this.onCompleted});

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<FocusNode> _keyboardFocusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
    _keyboardFocusNodes = List.generate(6, (index) => FocusNode());

    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
        if (_controllers.every((controller) => controller.text.length == 1)) {
          widget.onCompleted(
              _controllers.map((controller) => controller.text).join());
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in _keyboardFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 48,
          child: KeyboardListener(
            focusNode: _keyboardFocusNodes[index],
            onKeyEvent: (event) => _onKeyEvent(event, index),
            child: OtpInputField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) {
                if (value.length == 1 && index < 5) {
                  _focusNodes[index + 1].requestFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}