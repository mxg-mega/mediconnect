import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:uuid/uuid.dart';

class AddMedicationPage extends ConsumerStatefulWidget {
  final Medication? medication;
  const AddMedicationPage({super.key, this.medication});

  @override
  ConsumerState<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends ConsumerState<AddMedicationPage> {
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
  bool _showInfoBox = true;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    _nameController = TextEditingController(text: med?.name ?? '');
    _brandNameController = TextEditingController(text: med?.brandNames.isNotEmpty == true ? med!.brandNames.first : '');
    _manufacturerController = TextEditingController(text: med?.manufacturer ?? '');
    _categoryController = TextEditingController(text: med?.category ?? '');
    _strengthController = TextEditingController(text: med?.strengths.isNotEmpty == true ? med!.strengths.first : '');
    _dosageFormController = TextEditingController(text: med?.dosageForms.isNotEmpty == true ? med!.dosageForms.first : '');
    _quantityController = TextEditingController();
    _descriptionController = TextEditingController(text: med?.description ?? '');
    _benefitsController = TextEditingController(text: med?.usageInstructions ?? '');
    _stockController = TextEditingController();
    _reorderController = TextEditingController();
    _expiryController = TextEditingController();
    _priceController = TextEditingController();

    _showInfoBox = med != null;
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
      removeBodyPadding: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, theme),
            Padding(
              padding: EdgeInsets.all(context.figmaWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showInfoBox) _buildInfoBox(theme),
                    _buildImageUpload(theme),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Medication Info', theme),
                    _buildTextField('Medication Name(API)', _nameController, theme, isDropdown: true),
                    _buildDropdownField('Medication Type', ['Brand', 'Generic'], _medicationType, (val) => setState(() => _medicationType = val!), theme),
                    _buildTextField('Medication Type Name', _brandNameController, theme, isDropdown: true),
                    _buildTextField('Manufacturer', _manufacturerController, theme, isDropdown: true),
                    _buildTextField('Tags/Preferred Name(Optional)', TextEditingController(), theme),
                    SizedBox(height: context.figmaHeight(16)),
                    _buildTextField('Category', _categoryController, theme, isDropdown: true),
                    _buildTextField('Strength/Concentration', _strengthController, theme, isDropdown: true),
                    _buildTextField('Dosage Form', _dosageFormController, theme, isDropdown: true),
                    _buildTextField('Quantity per Pack', _quantityController, theme, isDropdown: true),
                    _buildTextField('Description', _descriptionController, theme, maxLines: 5),
                    _buildTextField('Benefits & Uses', _benefitsController, theme, maxLines: 4),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Inventory', theme),
                    _buildTextField('Current Stock Units', _stockController, theme, hint: 'Total stock available'),
                    _buildTextField('Reorder Point', _reorderController, theme, hint: 'e.g. \"Reorder when ≤ 10 units'),
                    _buildTextField(
                      'Expiration Date', 
                      _expiryController, 
                      theme, 
                      hint: 'Select expiry date',
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (picked != null) {
                          setState(() {
                            _expiryController.text = picked.toIso8601String().split('T')[0];
                          });
                        }
                      },
                    ),
                    SizedBox(height: context.figmaHeight(24)),
                    _buildSectionHeader('Medication Price', theme),
                    _buildTextField('Price(₦)', _priceController, theme, hint: 'e.g. 1000, 2000'),
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
            'Add Medication',
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

  Widget _buildInfoBox(AppColorsTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: context.figmaHeight(16)),
      padding: EdgeInsets.all(context.figmaWidth(12)),
      decoration: BoxDecoration(
        color: theme.support.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: theme.support.green, size: 20),
          SizedBox(width: context.figmaWidth(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fields below were automatically populated from the MedConnect medication catalog (description, benefits, dosage). Please review and edit if needed, then add the item to your inventory.',
                  style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => setState(() => _showInfoBox = false),
                    child: Text(
                      'Dismiss',
                      style: AppTextStyles.interP12R.copyWith(color: theme.support.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload(AppColorsTheme theme) {
    return Container(
      height: context.figmaHeight(200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.circular(context.figmaWidth(12)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(AppIcons.image_upload_placeholder, width: context.figmaWidth(150)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageButton(Icons.camera_alt_outlined, 'Camera', theme),
              SizedBox(width: context.figmaWidth(16)),
              _buildImageButton(Icons.image_outlined, 'Gallery', theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton(IconData icon, String label, AppColorsTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(16), vertical: context.figmaHeight(8)),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: context.figmaWidth(4)),
          Text(label, style: AppTextStyles.interP14M),
        ],
      ),
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

  Widget _buildTextField(String label, TextEditingController controller, AppColorsTheme theme, {bool isDropdown = false, int maxLines = 1, String? hint, bool readOnly = false, VoidCallback? onTap}) {
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
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
              filled: true,
              fillColor: theme.neutral.bgTint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.figmaWidth(8)),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.figmaWidth(8)),
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
                borderRadius: BorderRadius.circular(context.figmaWidth(8)),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.figmaWidth(8)),
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
      final pharmacyId = await ref.read(currentPharmacyIdProvider.future);
      
      if (pharmacyId == null || pharmacyId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No pharmacy associated with your account.')),
        );
        return;
      }

      print('DEBUG: AddMedicationPage - Attempting to save item. pharmacyId: $pharmacyId');
      
      final newItem = InventoryItem(
        id: const Uuid().v4(),
        pharmacyId: pharmacyId, 
        medicationId: widget.medication?.id ?? const Uuid().v4(),
        medicationName: _nameController.text,
        brandName: _brandNameController.text,
        form: _dosageFormController.text,
        quantityInStock: int.tryParse(_stockController.text) ?? 0,
        expiryDate: DateTime.tryParse(_expiryController.text) ?? DateTime.now().add(const Duration(days: 365)),
        purchasePrice: (double.tryParse(_priceController.text) ?? 0.0) * 0.8, 
        sellingPrice: double.tryParse(_priceController.text) ?? 0.0,
        minimumStockLevel: int.tryParse(_reorderController.text) ?? 10,
        stockStatus: StockStatus.determineStatus(int.tryParse(_stockController.text) ?? 0, int.tryParse(_reorderController.text) ?? 10),
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('DEBUG: AddMedicationPage - Saving item: ${newItem.medicationName} (${newItem.id}) to Firestore');

      await ref.read(inventoryProvider.notifier).addItem(newItem);
      
      if (mounted) {
        context.pop(); // Back to catalog
        context.pop(); // Back to inventory
      }
    }
  }
}
