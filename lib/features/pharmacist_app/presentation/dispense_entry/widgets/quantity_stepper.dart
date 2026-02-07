import 'package:flutter/material.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: Icon(Icons.remove, color: theme.neutral.secondaryText),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: Icon(Icons.add, color: theme.pharmacist.bg),
        ),
      ],
    );
  }
}
