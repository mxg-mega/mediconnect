import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

enum DocStatus { verified, pending, rejected }

class VerificationDoc {
  final String title;
  final String fileName;
  final String date;
  final String size;
  final DocStatus status;

  VerificationDoc({
    required this.title,
    required this.fileName,
    required this.date,
    required this.size,
    required this.status,
  });
}

class PharmacyVerificationPage extends ConsumerWidget {
  const PharmacyVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);

    final docs = [
      VerificationDoc(
        title: 'Frontal Pharmacy Image',
        fileName: 'Apogee_Pharmacy.png',
        date: 'Aug 04, 2025',
        size: '1.9 MB',
        status: DocStatus.verified,
      ),
      VerificationDoc(
        title: 'Pharmacy license',
        fileName: 'Pharmacy_license.pdf',
        date: 'Aug 04, 2025',
        size: '1.9 MB',
        status: DocStatus.verified,
      ),
      VerificationDoc(
        title: 'Proof of Business Registration',
        fileName: 'CAC_Certificate.pdf',
        date: 'Aug 04, 2025',
        size: '1.9 MB',
        status: DocStatus.pending,
      ),
      VerificationDoc(
        title: 'PCN Certificate',
        fileName: 'PCN_Certificate.pdf',
        date: 'Aug 04, 2025',
        size: '1.9 MB',
        status: DocStatus.pending,
      ),
      VerificationDoc(
        title: 'Proof of address',
        fileName: 'Government ID.pdf',
        date: 'Aug 04, 2025',
        size: '1.9 MB',
        status: DocStatus.verified,
      ),
    ];

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Pharmacy Verification'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBox(theme),
            SizedBox(height: context.figmaHeight(24)),
            ...docs.map((doc) => _buildDocCard(context, doc, theme)),
            SizedBox(height: context.figmaHeight(16)),
            Text(
              'PCN registration',
              style: AppTextStyles.interP16M.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildReadOnlyField('PCN ID Number', 'PCN-123456', theme),
            _buildReadOnlyField(
              'Agency',
              'Pharmacists Council of Nigeria (PCN)',
              theme,
            ),
            SizedBox(height: context.figmaHeight(32)),
            KElevatedButton(
              onPressed: () {},
              child: const Text('Upload more documents'),
            ),
            SizedBox(height: context.figmaHeight(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(AppColorsTheme theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.support.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.support.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Uploaded documents will be reviewed within 24-72 hrs.',
              style: AppTextStyles.interP12R.copyWith(
                color: theme.neutral.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard(
    BuildContext context,
    VerificationDoc doc,
    AppColorsTheme theme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.neutral.bgTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  doc.fileName.endsWith('.pdf')
                      ? Icons.picture_as_pdf
                      : Icons.image,
                  color: doc.fileName.endsWith('.pdf')
                      ? theme.support.red
                      : theme.support.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.title, style: AppTextStyles.interP14M),
                    Text(
                      doc.fileName,
                      style: AppTextStyles.interP14M.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Uploaded ${doc.date} • ${doc.size}',
                      style: AppTextStyles.interP12R.copyWith(
                        color: theme.neutral.tertiaryText,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(doc.status, theme),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionText(
                'View',
                theme.support.blue,
                () => _showViewModal(context, doc, theme),
              ),
              _buildActionText('Download', theme.support.blue, () {}),
              _buildActionText(
                'Replace',
                theme.support.blue,
                () => _showReplaceModal(context, doc, theme),
              ),
              _buildActionText(
                'Delete',
                theme.support.red,
                () => _showDeleteModal(context, doc, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(DocStatus status, AppColorsTheme theme) {
    final color = status == DocStatus.verified
        ? theme.support.green
        : theme.support.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status == DocStatus.verified ? 'Verified' : 'Pending',
        style: AppTextStyles.interP12M.copyWith(color: color),
      ),
    );
  }

  Widget _buildActionText(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.interP12M.copyWith(color: color)),
    );
  }

  Widget _buildReadOnlyField(String label, String value, AppColorsTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.interP12R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.neutral.border.withValues(alpha: 0.1),
              ),
            ),
            child: Text(value, style: AppTextStyles.interP14R),
          ),
        ],
      ),
    );
  }

  void _showViewModal(
    BuildContext context,
    VerificationDoc doc,
    AppColorsTheme theme,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      doc.fileName,
                      style: AppTextStyles.interP16M,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                color: theme.neutral.bgTint,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 48,
                      color: theme.support.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pdf preview would be shown here',
                      style: AppTextStyles.interP14R.copyWith(
                        color: theme.neutral.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Download',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Replace',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReplaceModal(
    BuildContext context,
    VerificationDoc doc,
    AppColorsTheme theme,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Replace Document', style: AppTextStyles.interP16M),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Required: JPG, PNG, PDF - max 5mb',
                style: AppTextStyles.interP14R.copyWith(
                  color: theme.neutral.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.pharmacist.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Browse Files',
                          style: AppTextStyles.interP14M.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No File Chosen',
                    style: AppTextStyles.interP14R.copyWith(
                      color: theme.neutral.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Upload',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteModal(
    BuildContext context,
    VerificationDoc doc,
    AppColorsTheme theme,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delete Document', style: AppTextStyles.interP16M),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Are you sure you want to permanently delete "${doc.fileName}"? This action cannot be undone.',
                style: AppTextStyles.interP14R.copyWith(
                  color: theme.neutral.primaryText,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: theme.support.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
