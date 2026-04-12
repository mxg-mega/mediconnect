import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventoryItemEditPage extends ConsumerStatefulWidget {
  final InventoryItem item;
  const InventoryItemEditPage({super.key, required this.item});

  @override
  ConsumerState<InventoryItemEditPage> createState() => _InventoryItemEditPageState();
}

class _InventoryItemEditPageState extends ConsumerState<InventoryItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandNameController;
  late TextEditingController _manufacturerController;
  late TextEditingController _categoryController;
  late TextEditingController _strengthController;
  late TextEditingController _dosageFormController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _benefitsController;
  late TextEditingController _stockController;
  late TextEditingController _reorderController;
  late TextEditingController _expiryController;
  late TextEditingController _priceController;

  String _medicationType = 'Brand';

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item.medicationName);
    _brandNameController = TextEditingController(text: item.brandName);
    _manufacturerController = TextEditingController(text: 'GlaxoSmithKline'); // Mock
    _categoryController = TextEditingController(text: 'Antibiotics'); // Mock
    _strengthController = TextEditingController(text: '500MG'); // Mock
    _dosageFormController = TextEditingController(text: item.form);
    _quantityController = TextEditingController(text: "10's"); // Mock
    _descriptionController = TextEditingController(text: 'Amoxicillin is an aminopenicillin...');
    _benefitsController = TextEditingController(text: 'Respiratory tract infections...');
    _stockController = TextEditingController(text: item.quantityInStock.toString());
    _reorderController = TextEditingController(text: item.minimumStockLevel.toString());
    _expiryController = TextEditingController(text: '${item.expiryDate.year}-${item.expiryDate.month.toString().padLeft(2, '0')}-${item.expiryDate.day.toString().padLeft(2, '0')}');
    _priceController = TextEditingController(text: item.sellingPrice.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandNameController.dispose();
    _manufacturerController.dispose();
    _categoryController.dispose();
    _strengthController.dispose();
    _dosageFormController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _benefitsController.dispose();
    _stockController.dispose();
    _reorderController.dispose();
    _expiryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, theme),
            _buildImage(context, theme),
            Padding(
              padding: EdgeInsets.all(context.figmaWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Medication Name(API)', _nameController, theme, isDropdown: true),
                    _buildDropdownField('Medication Type', ['Brand', 'Generic'], _medicationType, (val) => setState(() => _medicationType = val!), theme),
                    _buildTextField('Medication Type Name', _brandNameController, theme, isDropdown: true),
                    _buildTextField('Manufacturer', _manufacturerController, theme, isDropdown: true),
                    _buildTextField('Tags/Preferred Name(Optional)', TextEditingController(), theme),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Medication Info', theme),
                    _buildTextField('Category', _categoryController, theme, isDropdown: true),
                    _buildTextField('Strength/Concentration', _strengthController, theme, isDropdown: true),
                    _buildTextField('Dosage Form', _dosageFormController, theme, isDropdown: true),
                    _buildTextField('Quantity per Pack', _quantityController, theme, isDropdown: true),
                    _buildTextField('Description', _descriptionController, theme, maxLines: 5),
                    _buildTextField('Benefits & Uses', _benefitsController, theme, maxLines: 4),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Inventory', theme),
                    _buildTextField('Current Stock Units', _stockController, theme),
                    _buildTextField('Reorder Point', _reorderController, theme),
                    _buildTextField('Expiration Date', _expiryController, theme),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Medication Price', theme),
                    _buildTextField('Price(₦)', _priceController, theme),
                    SizedBox(height: context.figmaHeight(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(16),
        vertical: context.figmaHeight(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
            'Inventory Item',
            style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
          ),
          TextButton(
            onPressed: _onSave,
            child: Text(
              'Save',
              style: AppTextStyles.interP16M.copyWith(color: theme.pharmacist.bg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, AppColorsTheme theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: context.figmaHeight(200),
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.item.imageUrl ?? 'assets/images/amoxicillin_gsk.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text('Edit', style: AppTextStyles.interP14M.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, AppColorsTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 16),
          height: 2,
          width: 40,
          color: theme.pharmacist.bg,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, AppColorsTheme theme, {bool isDropdown = false, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
              filled: true,
              fillColor: theme.neutral.bgTint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value, Function(String?) onChanged, AppColorsTheme theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.neutral.bgTint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = widget.item.copyWith(
        medicationName: _nameController.text,
        brandName: _brandNameController.text,
        form: _dosageFormController.text,
        quantityInStock: int.tryParse(_stockController.text) ?? 0,
        expiryDate: DateTime.tryParse(_expiryController.text) ?? widget.item.expiryDate,
        sellingPrice: double.tryParse(_priceController.text) ?? 0.0,
        minimumStockLevel: int.tryParse(_reorderController.text) ?? 10,
        stockStatus: StockStatus.determineStatus(
          int.tryParse(_stockController.text) ?? 0,
          int.tryParse(_reorderController.text) ?? 10,
        ),
        updatedAt: DateTime.now(),
      );

      await ref.read(inventoryProvider.notifier).updateItem(updatedItem);
      
      if (mounted) {
        context.pop();
      }
    }
  }
}
