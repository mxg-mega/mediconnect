import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';

class UploadButton extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;

  const UploadButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appScaffoldProvider.notifier);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.getBackgroundColor(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 18),
      label: Text(text),
    );
  }
}
