import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class PharmacistVerificationForm extends StatefulWidget {
  const PharmacistVerificationForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final void Function(PharmacyVerificationInput input) onSubmit;

  @override
  State<PharmacistVerificationForm> createState() =>
      _PharmacistVerificationFormState();
}

class _PharmacistVerificationFormState
    extends State<PharmacistVerificationForm> {
  final TextEditingController pcnIdController = TextEditingController();
  final TextEditingController agencyController = TextEditingController();
  bool hasCheckedBox = false;

  // In lieu of file picker integration, capture placeholder paths/ids
  String? frontalPath;
  String? licensePath;
  String? businessRegPath;
  String? pcnCertPath;
  String? addressProofPath;
  String? additionalCertPath;

  @override
  void dispose() {
    pcnIdController.dispose();
    agencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Pharmacy Verification', style: AppTextStyles.inter24M),
          SizedBox(height: context.figmaHeight(32)),
          Text(
            'Please upload clear, valid copies of the following documents. Verification may take 24-72 hours.',
            style: AppTextStyles.interP16M.copyWith(
              color: AppTheme.colors(context).neutral.secondaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(32)),

          // form contents
          _UploadField(
            label: 'Upload Frontal Pharmacy Image',
            // required: true,
            onPick: (path) => frontalPath = path,
          ),
          _UploadField(
            label: 'Pharmacy license upload',
            // required: true,
            onPick: (path) => licensePath = path,
          ),
          _UploadField(
            label: 'Proof of Business Registration',
            // required: true,
            onPick: (path) => businessRegPath = path,
          ),

          Text('PCN Registration:'),

          LabeledInput(
            label: 'PCN ID Number Input',
            required: true,
            child: KFormField(
              hintText: 'PCN-123456',
              controller: pcnIdController,
              validator: _required,
            ),
          ),
          LabeledInput(
            label: 'Agency Selection (State/Fedral)',
            required: true,
            child: KFormField(
              hintText: 'State / Federal',
              controller: agencyController,
              validator: _required,
            ),
          ),
          _UploadField(
            label: 'PCN Certificate Upload',
            // required: true,
            onPick: (path) => pcnCertPath = path,
          ),
          _UploadField(
            label: 'Proof of address (utility bill/government ID)',
            // required: true,
            onPick: (path) => addressProofPath = path,
          ),

          _UploadField(
            label:
                'Additional Certifications (ISO Certifications, Vaccination Certification, Narcotics License e.t.c)',
            // required: true,
            onPick: (path) => additionalCertPath = path,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                activeColor: AppTheme.colors(context).pharmacist.bg,
                value: hasCheckedBox,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    hasCheckedBox = value;
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: RichText(
                  softWrap: true,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'I hereby certify that all information and documents provided are true, accurate, and belong to the stated pharmacy. I agree to the ',
                        style: AppTextStyles.interP14R.copyWith(
                          color: AppTheme.colors(context).neutral.secondaryText,
                        ),
                      ),
                      TextSpan(
                        text: 'Term of Service',
                        style: AppTextStyles.interP14R.copyWith(
                          color: AppTheme.colors(context).support.red,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: AppTextStyles.interP14R.copyWith(
                          color: AppTheme.colors(context).neutral.secondaryText,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: AppTextStyles.interP14R.copyWith(
                          color: AppTheme.colors(context).support.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              SvgPicture.asset(
                AppIcons.lock,
                // colorFilter: ColorFilter.mode(
                //   AppTheme.colors(context).pharmacist.bg,
                //   BlendMode.color,
                // ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'All Information are encrypted and securely stored',
                  style: AppTextStyles.interP12R.copyWith(
                    color: AppTheme.colors(context).neutral.secondaryText,
                  ),
                ),
              ),
            ],
          ),

          KElevatedButton(onPressed: _submit, child: const Text('Next')),

          Container(
            width: double.infinity,
            height: context.figmaHeight(54),
            foregroundDecoration: BoxDecoration(
              color: AppTheme.colors(context).pharmacist.bgTint,
            ),
            child: DropdownButton(
              items: [],
              onChanged: (value) {},
              hint: Text(
                'Need help with verification?',
                style: AppTextStyles.interP16M.copyWith(
                  color: AppTheme.colors(context).neutral.bg00,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    return null;
  }

  bool _hasFiles() {
    return frontalPath != null &&
        licensePath != null &&
        businessRegPath != null &&
        pcnCertPath != null &&
        addressProofPath != null &&
        additionalCertPath != null;
  }

  void _submit() {
    if (widget.formKey.currentState?.validate() != true) return;
    if (!hasCheckedBox) return;
    // if (!_hasFiles()) return;

    final input = PharmacyVerificationInput(
      frontalImagePath: frontalPath,
      licensePath: licensePath,
      businessRegPath: businessRegPath,
      pcnIdNumber: pcnIdController.text.trim(),
      agencySelection: agencyController.text.trim(),
      pcnCertificatePath: pcnCertPath,
      addressProofPath: addressProofPath,
      additionalCertPath: additionalCertPath,
      consentAccepted: hasCheckedBox,
    );

    widget.onSubmit(input);
  }
}

class _UploadField extends StatelessWidget {
  const _UploadField({
    required this.label,
    required this.onPick,
    this.required = false,
  });

  final String label;
  final void Function(String path) onPick;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return LabeledInput(
      label: label,
      required: required,
      child: OutlinedButton(
        onPressed: () {
          // Placeholder path; integrate file picker later
          onPick('placeholder_path');
        },
        child: const Text('Upload'),
      ),
    );
  }
}
