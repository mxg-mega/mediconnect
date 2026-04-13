import 'package:flutter/material.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PatientPersonalInfoForm extends StatefulWidget {
  const PatientPersonalInfoForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;

  final void Function(PatientInfoInput input) onSubmit;

  @override
  State<PatientPersonalInfoForm> createState() =>
      PatientPersonalInfoFormState();
}

class PatientPersonalInfoFormState extends State<PatientPersonalInfoForm> {
  final fullName = TextEditingController();

  final phoneNumber = TextEditingController();

  final email = TextEditingController();

  final dateOfBirthController = TextEditingController();

  var genderValue = '';

  DateTime? dateOfBirth;

  final address = TextEditingController();

  final emergencyContact = TextEditingController();

  void quickFill() {
    setState(() {
      fullName.text = 'Patient Test';
      email.text = 'patient@test.com';
      phoneNumber.text = '08012345678';
      dateOfBirth = DateTime(1995, 5, 20);
      dateOfBirthController.text = '20/5/1995';
      genderValue = 'male';
      address.text = '456 Test Street, Lagos';
      emergencyContact.text = '08098765432';
    });
  }

  @override
  void dispose() {
    fullName.dispose();
    phoneNumber.dispose();
    email.dispose();
    dateOfBirthController.dispose();
    address.dispose();
    emergencyContact.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Personal Details', style: AppTextStyles.inter24M),
          const SizedBox(height: 16),
          Text(
            'Complete your profile to get started.',
            style: AppTextStyles.interP16M.copyWith(
              color: AppTheme.colors(context).neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'FullName',
            required: true,
            child: KFormField(
              hintText: 'John Doe',
              controller: fullName,
              validator: _requiredValidator,
            ),
          ),
          LabeledInput(
            label: 'Email',
            required: true,
            child: KFormField(
              hintText: 'John Doe',
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ),
          LabeledInput(
            label: 'Mobile Number (Whatsapp)',
            required: true,
            child: KFormField(
              hintText: '+234 123 4567 890',
              controller: phoneNumber,
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
            ),
          ),
          LabeledInput(
            label: 'Date of Birth',
            required: true,
            child: KInputField(
              child: TextFormField(
                readOnly: true,
                controller: dateOfBirthController,
                decoration: const InputDecoration(
                  hintText: 'Select Date of Birth',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (dateOfBirth == null) return 'Select date of birth';
                  return null;
                },
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateOfBirth ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 100),
                    ),
                  );
                  if (picked != null && picked != dateOfBirth) {
                    setState(() {
                      dateOfBirth = picked;
                      dateOfBirthController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                },
              ),
            ),
          ),
          LabeledInput(
            label: 'Gender',
            required: true,
            child: KInputField(
              child: DropdownButtonFormField<String>(
                // initialValue: genderValue,
                hint: const Text('Select Gender'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value == null || value.isEmpty) {
                    return;
                  }
                  setState(() {
                    genderValue = value;
                  });
                },
              ),
            ),
          ),

          LabeledInput(
            label: 'Address',
            required: true,
            child: KFormField(
              hintText: '123 Quaters Abuja',
              controller: address,
              validator: _requiredValidator,
            ),
          ),
          LabeledInput(
            label: 'Emergency Contact',
            required: true,
            child: KFormField(
              hintText: '+234 123 4567 890',
              controller: emergencyContact,
              validator: _requiredValidator,
              keyboardType: TextInputType.phone,
            ),
          ),
          KElevatedButton(onPressed: _submit, child: const Text('Next')),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submit() {
    if (widget.formKey.currentState?.validate() != true) return;

    final input = PatientInfoInput(
      fullName: fullName.text.trim(),
      email: email.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      dateOfBirth: dateOfBirth,
      gender: genderValue,
      address: address.text.trim(),
      emergencyContact: emergencyContact.text.trim(),
    );
    widget.onSubmit(input);
  }
}
