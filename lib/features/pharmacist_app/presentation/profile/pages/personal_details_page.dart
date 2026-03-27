import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class PersonalDetailsPage extends ConsumerStatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  ConsumerState<PersonalDetailsPage> createState() =>
      _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends ConsumerState<PersonalDetailsPage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _displayNameController = TextEditingController(
      text: 'Pharmacist ${user?.firstName ?? ''}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Personal Details'),
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
              style: AppTextStyles.interP16M.copyWith(
                color: theme.support.green,
              ),
            ),
          ),
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Full Name', _nameController, theme),
            _buildField(
              'Title/role',
              TextEditingController(text: 'Pharmacist'),
              theme,
              enabled: false,
            ),
            _buildField('Display Name', _displayNameController, theme),
            SizedBox(height: context.figmaHeight(24)),
            Text(
              'Contact Info',
              style: AppTextStyles.interP18M.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildField(
              'Email',
              TextEditingController(text: user?.email ?? ''),
              theme,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    AppColorsTheme theme, {
    bool enabled = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.interP14M.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(8)),
          TextFormField(
            controller: controller,
            enabled: _isEditing && enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: _isEditing && enabled
                  ? Colors.transparent
                  : theme.neutral.bgTint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.neutral.border.withValues(alpha: 0.3),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.neutral.border.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
