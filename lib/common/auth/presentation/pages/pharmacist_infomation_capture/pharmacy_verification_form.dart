import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/data/models/capture_models.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/document_pick_preview_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

typedef PharmacyVerificationSubmit = void Function(
  PharmacyVerificationInput input, {
  required Map<String, PlatformFile?> files,
});

class PharmacistVerificationForm extends ConsumerStatefulWidget {
  const PharmacistVerificationForm({
    super.key,
    required this.formKey,
    this.isLoading = false,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final PharmacyVerificationSubmit onSubmit;

  @override
  ConsumerState<PharmacistVerificationForm> createState() =>
      _PharmacistVerificationFormState();
}

class _PharmacistVerificationFormState
    extends ConsumerState<PharmacistVerificationForm> {
  final TextEditingController pcnIdController = TextEditingController();
  final TextEditingController agencyController = TextEditingController();
  bool hasCheckedBox = false;

  PlatformFile? frontalFile;
  PlatformFile? licenseFile;
  PlatformFile? businessRegFile;
  PlatformFile? pcnCertFile;
  PlatformFile? addressProofFile;
  PlatformFile? additionalCertFile;

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
          DocumentPickPreviewField(
            label: 'Upload Frontal Pharmacy Image',
            file: frontalFile,
            onPick: (file) => setState(() => frontalFile = file),
            onRemove: () => setState(() => frontalFile = null),
          ),
          DocumentPickPreviewField(
            label: 'Pharmacy license upload',
            file: licenseFile,
            onPick: (file) => setState(() => licenseFile = file),
            onRemove: () => setState(() => licenseFile = null),
          ),
          DocumentPickPreviewField(
            label: 'Proof of Business Registration',
            file: businessRegFile,
            onPick: (file) => setState(() => businessRegFile = file),
            onRemove: () => setState(() => businessRegFile = null),
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
          DocumentPickPreviewField(
            label: 'PCN Certificate Upload',
            file: pcnCertFile,
            onPick: (file) => setState(() => pcnCertFile = file),
            onRemove: () => setState(() => pcnCertFile = null),
          ),
          DocumentPickPreviewField(
            label: 'Proof of address (utility bill/government ID)',
            file: addressProofFile,
            onPick: (file) => setState(() => addressProofFile = file),
            onRemove: () => setState(() => addressProofFile = null),
          ),
          DocumentPickPreviewField(
            label:
                'Additional Certifications (ISO Certifications, Vaccination Certification, Narcotics License e.t.c)',
            file: additionalCertFile,
            onPick: (file) => setState(() => additionalCertFile = file),
            onRemove: () => setState(() => additionalCertFile = null),
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
              SvgPicture.asset(AppIcons.lock),
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
          KElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Next'),
          ),
          Container(
            width: double.infinity,
            height: context.figmaHeight(54),
            foregroundDecoration: BoxDecoration(
              color: AppTheme.colors(context).pharmacist.bgTint,
            ),
            child: DropdownButton(
              items: const [],
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

  void _submit() {
    if (widget.formKey.currentState?.validate() != true) return;
    if (!hasCheckedBox) return;

    final files = <String, PlatformFile?>{
      'frontal': frontalFile,
      'license': licenseFile,
      'business_reg': businessRegFile,
      'pcn_cert': pcnCertFile,
      'address_proof': addressProofFile,
      'additional_cert': additionalCertFile,
    };

    final input = PharmacyVerificationInput(
      frontalImagePath: frontalFile?.name,
      licensePath: licenseFile?.name,
      businessRegPath: businessRegFile?.name,
      pcnIdNumber: pcnIdController.text.trim(),
      agencySelection: agencyController.text.trim(),
      pcnCertificatePath: pcnCertFile?.name,
      addressProofPath: addressProofFile?.name,
      additionalCertPath: additionalCertFile?.name,
      consentAccepted: hasCheckedBox,
    );

    widget.onSubmit(input, files: files);
  }
}
