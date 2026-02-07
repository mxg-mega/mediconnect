import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventorySearchBar extends ConsumerStatefulWidget {
  const InventorySearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<InventorySearchBar> createState() => _InventorySearchBarState();
}

class _InventorySearchBarState extends ConsumerState<InventorySearchBar> {
  final _textController = TextEditingController();
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 300), () {
      ref.read(inventoryProvider.notifier).search(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Search Medications by name, brand, or...',
          prefixIcon: Icon(Icons.search, color: colors.neutral.secondaryText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.neutral.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.neutral.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.patient.bg, width: 2),
          ),
        ),
      ),
    );
  }
}
