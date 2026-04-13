import 'package:flutter/material.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PharmacyInfoForm extends StatefulWidget {
  const PharmacyInfoForm({
    super.key,
    required this.onSubmit,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final void Function(PharmacyInfoInput input) onSubmit;

  @override
  State<PharmacyInfoForm> createState() => PharmacyInfoFormState();
}

class PharmacyInfoFormState extends State<PharmacyInfoForm> {
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController titleRoleController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void quickFill() {
    setState(() {
      pharmacyNameController.text = 'Test Pharmacy Ltd';
      titleRoleController.text = 'Head Pharmacist';
      contactController.text = '08011122233';
      emailController.text = 'pharmacy@test.com';
      addressController.text = '123 Business Way, Abuja';
      descriptionController.text = 'A reliable pharmacy providing quality care.';
      _selectedType = PharmacyType.retail;
      _selectedOperatingHours = '24/7';
    });
  }

  @override
  void dispose() {
    pharmacyNameController.dispose();
    titleRoleController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Personal Details', style: AppTextStyles.inter24M),
          const SizedBox(height: 16),
          Text(
            'Complete your pharmacy’s profile below.',
            style: AppTextStyles.interP16M.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Pharmacy Name',
            required: true,
            child: KFormField(
              hintText: 'Medconnect Pharmacy Limited',
              controller: pharmacyNameController,
              validator: _required,
            ),
          ),
          LabeledInput(
            label: 'Title/Role',
            required: true,
            // TODO: make sure to follow the design, temporarily making it an input field
            child: KFormField(
              hintText: 'Pharmacist',
              controller: titleRoleController,
              validator: _required,
            ),
          ),
          LabeledInput(
            label: 'Pharmacy Contact',
            required: true,
            child: KFormField(
              hintText: '+234 123 4567 890',
              controller: contactController,
              validator: _required,
              keyboardType: TextInputType.phone,
            ),
          ),
          LabeledInput(
            label: 'Pharmacy Email',
            required: true,
            child: KFormField(
              hintText: 'pharmacy@medconnect.com',
              controller: emailController,
              validator: _required,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          LabeledInput(
            label: 'Pharmacy Address',
            required: true,
            child: KFormField(
              hintText: '123 Quarters Abuja',
              controller: addressController,
              validator: _required,
            ),
          ),
          LabeledInput(
            label: 'Operating Hours',
            required: true,
            child: KInputField(
              child: DropdownButtonFormField<String>(
                hint: const Text('Select operating hours'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: '24/7', child: Text('24/7')),
                  DropdownMenuItem(
                    value: '6AM-10PM',
                    child: Text('6:00 AM - 10:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: '8AM-8PM',
                    child: Text('8:00 AM - 8:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: '9AM-6PM',
                    child: Text('9:00 AM - 6:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: 'custom',
                    child: Text('Custom Hours'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select operating hours';
                  }
                  return null;
                },
                onChanged: (value) {
                  _selectedOperatingHours = value;
                },
              ),
            ),
          ),
          LabeledInput(
            label: 'Pharmacy Type (Wholesale/Retail)',
            required: true,
            child: KInputField(
              child: DropdownButtonFormField<String>(
                hint: const Text('Select pharmacy type'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'retail', child: Text('Retail')),
                  DropdownMenuItem(
                    value: 'wholesale',
                    child: Text('Wholesale'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select pharmacy type';
                  }
                  return null;
                },
                onChanged: (value) {
                  _selectedType = value == 'wholesale'
                      ? PharmacyType.wholesale
                      : PharmacyType.retail;
                },
              ),
            ),
          ),
          LabeledInput(
            label:
                'Pharmacy Description (Specialty services, Unique offerings)',
            child: KFormField(
              hintText: 'Description',
              maxLength: 200,
              controller: descriptionController,
            ),
          ),

          KElevatedButton(onPressed: _submit, child: const Text('Next')),
        ],
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    return null;
  }

  PharmacyType _selectedType = PharmacyType.retail;
  String? _selectedOperatingHours;

  void _submit() {
    if (widget.formKey.currentState?.validate() != true) return;
    final input = PharmacyInfoInput(
      pharmacyName: pharmacyNameController.text.trim(),
      titleOrRole: titleRoleController.text.trim(),
      contactNumber: contactController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      operatingHours: _selectedOperatingHours ?? '',
      type: _selectedType,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
    );
    widget.onSubmit(input);
  }
}
