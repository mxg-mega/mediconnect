import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_provider.dart';

class PharmacyInformationPage extends ConsumerStatefulWidget {
  const PharmacyInformationPage({super.key});

  @override
  ConsumerState<PharmacyInformationPage> createState() =>
      _PharmacyInformationPageState();
}

class _PharmacyInformationPageState
    extends ConsumerState<PharmacyInformationPage> {
  bool _isEditing = false;
  bool _isSaving = false;
  bool _hasPopulated = false;
  Pharmacy? _pharmacy;

  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _typeController;
  late TextEditingController _operatingHoursController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roleController = TextEditingController(text: 'Pharmacist');
    _contactController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _descriptionController = TextEditingController();
    _typeController = TextEditingController();
    _operatingHoursController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  void _populateFromPharmacy(Pharmacy pharmacy) {
    _pharmacy = pharmacy;
    final user = ref.read(currentUserProvider);
    _nameController.text = pharmacy.name;
    _roleController.text =
        user != null ? 'Pharmacist ${user.firstName}' : 'Pharmacist';
    _contactController.text = pharmacy.phoneNumber;
    _emailController.text = pharmacy.email;
    _addressController.text = pharmacy.address;
    _descriptionController.text = pharmacy.description ?? '';
    _typeController.text = pharmacy.type.displayName;
    _operatingHoursController.text = pharmacy.operatingHours.isEmpty
        ? 'Not set'
        : pharmacy.operatingHours.first.openTime;
  }

  Future<void> _save() async {
    final pharmacy = _pharmacy;
    if (pharmacy == null) return;

    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || contact.isEmpty || email.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required pharmacy fields.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updated = pharmacy.copyWith(
        name: name,
        phoneNumber: contact,
        email: email,
        businessEmail: email,
        address: address,
        description: _descriptionController.text.trim(),
        location: pharmacy.location.copyWith(address: address),
        isRegistrationComplete: true,
        updatedAt: DateTime.now(),
      );

      await ref.read(updatePharmacyInfoUseCaseProvider)(updated);

      ref.invalidate(currentPharmacyProvider);
      ref.invalidate(currentPharmacyStatusProvider);

      setState(() {
        _pharmacy = updated;
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pharmacy information saved.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save pharmacy information: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final pharmacyAsync = ref.watch(currentPharmacyProvider);

    ref.listen(currentPharmacyProvider, (previous, next) {
      next.whenData((pharmacy) {
        if (pharmacy != null && !_hasPopulated && mounted) {
          _populateFromPharmacy(pharmacy);
          setState(() => _hasPopulated = true);
        }
      });
    });

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Pharmacy Information'),
      scaffoldActions: [
        if (!_isEditing)
          IconButton(
            onPressed: pharmacyAsync.isLoading || _pharmacy == null
                ? null
                : () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_outlined),
          )
        else
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? SizedBox(
                    width: context.figmaWidth(16),
                    height: context.figmaWidth(16),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Done',
                    style: AppTextStyles.interP16M.copyWith(
                      color: theme.support.green,
                    ),
                  ),
          ),
      ],
      body: pharmacyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.figmaWidth(16)),
            child: Text(
              'Failed to load pharmacy information: $error',
              style: AppTextStyles.interP14M,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (_) => SingleChildScrollView(
          padding: EdgeInsets.all(context.figmaWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Pharmacy Name', _nameController, theme),
              _buildField('Title/Role', _roleController, theme, enabled: false),
              _buildField('Pharmacy Contact', _contactController, theme),
              _buildField('Pharmacy Email', _emailController, theme),
              _buildField('Pharmacy Address', _addressController, theme),
              _buildField(
                'Pharmacy Operating Hours',
                _operatingHoursController,
                theme,
                enabled: false,
              ),
              _buildField(
                'Pharmacy Type (Wholesale/Retail)',
                _typeController,
                theme,
                enabled: false,
              ),
              _buildField(
                'Pharmacy Description (Specialty services, Unique offerings)',
                _descriptionController,
                theme,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    AppColorsTheme theme, {
    bool enabled = true,
    int maxLines = 1,
  }) {
    final fieldEnabled = _isEditing && enabled;

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
            enabled: fieldEnabled,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldEnabled
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
