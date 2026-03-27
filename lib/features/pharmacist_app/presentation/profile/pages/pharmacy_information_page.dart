import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class PharmacyInformationPage extends ConsumerStatefulWidget {
  const PharmacyInformationPage({super.key});

  @override
  ConsumerState<PharmacyInformationPage> createState() => _PharmacyInformationPageState();
}

class _PharmacyInformationPageState extends ConsumerState<PharmacyInformationPage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Apogee Pharmacy & Stores');
    _roleController = TextEditingController(text: 'Pharmacist');
    _contactController = TextEditingController(text: '+234 123 4567 890');
    _emailController = TextEditingController(text: 'Apogee Pharmacy@gmail.com');
    _addressController = TextEditingController(text: 'Wuse 2, Abuja');
    _descriptionController = TextEditingController(text: 'Family-friendly community pharmacy offering fast prescription fills, expert counselling, genuine brands, transparent pricing, and professional advice—backed by a satisfaction...');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Pharmacy Information'),
      scaffoldActions: [
        if (!_isEditing)
          IconButton(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_outlined),
          )
        else
          TextButton(
            onPressed: () => setState(() => _isEditing = false),
            child: Text(
              'Done',
              style: AppTextStyles.interP16M.copyWith(color: theme.support.green),
            ),
          ),
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Pharmacy Name', _nameController, theme),
            _buildField('Title/Role', _roleController, theme, isDropdown: _isEditing),
            _buildField('Pharmacy Contact', _contactController, theme),
            _buildField('Pharmacy Email', _emailController, theme),
            _buildField('Pharmacy Address', _addressController, theme),
            Row(
              children: [
                Expanded(child: _buildField('Pharmacy Operating Hours', TextEditingController(text: 'Open 24 hours (Every day)'), theme)),
                SizedBox(width: context.figmaWidth(16)),
                Expanded(child: _buildField('Holidays & Exceptions', TextEditingController(text: 'No exceptions added'), theme)),
              ],
            ),
            _buildField('Pharmacy Type (Wholesale/Retail)', TextEditingController(text: 'Wholesale'), theme, isDropdown: _isEditing),
            _buildField('Pharmacy Description (Specialty services, Unique offerings)', _descriptionController, theme, maxLines: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, AppColorsTheme theme, {bool isDropdown = false, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText),
          ),
          SizedBox(height: context.figmaHeight(8)),
          TextFormField(
            controller: controller,
            enabled: _isEditing,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: _isEditing ? Colors.transparent : theme.neutral.bgTint,
              suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.3)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border.withValues(alpha: 0.1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
