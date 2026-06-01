import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy_verification_document.dart';
import 'package:mediconnect/common/auth/domain/utils/pharmacy_verification_docs.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/document_pick_preview_field.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/services/document_upload_service.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/document_url_utils.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/core/utils/local_file_writer.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum DocStatus { verified, pending, rejected }

enum PharmacyVerificationDocType {
  frontal,
  license,
  businessRegistration,
  pcnCertificate,
  addressProof,
  additionalCert,
}

extension PharmacyVerificationDocTypeX on PharmacyVerificationDocType {
  String get title => switch (this) {
        PharmacyVerificationDocType.frontal => 'Frontal Pharmacy Image',
        PharmacyVerificationDocType.license => 'Pharmacy license',
        PharmacyVerificationDocType.businessRegistration =>
          'Proof of Business Registration',
        PharmacyVerificationDocType.pcnCertificate => 'PCN Certificate',
        PharmacyVerificationDocType.addressProof => 'Proof of address',
        PharmacyVerificationDocType.additionalCert =>
          'Additional Certifications',
      };

  String get storageFolder => switch (this) {
        PharmacyVerificationDocType.frontal => 'frontal',
        PharmacyVerificationDocType.license => 'license',
        PharmacyVerificationDocType.businessRegistration =>
          'business_registration',
        PharmacyVerificationDocType.pcnCertificate => 'pcn_certificate',
        PharmacyVerificationDocType.addressProof => 'address_proof',
        PharmacyVerificationDocType.additionalCert => 'additional',
      };

  /// Index within [Pharmacy.licenseDocumentUrls] when applicable.
  int? get licenseSlotIndex => switch (this) {
        PharmacyVerificationDocType.frontal => null,
        PharmacyVerificationDocType.license => 0,
        PharmacyVerificationDocType.businessRegistration => 1,
        PharmacyVerificationDocType.pcnCertificate => 2,
        PharmacyVerificationDocType.addressProof => 3,
        PharmacyVerificationDocType.additionalCert => 4,
      };
}

class VerificationDoc {
  final PharmacyVerificationDocType type;
  final String title;
  final String? fileName;
  final String? url;
  final String date;
  final DocStatus status;

  VerificationDoc({
    required this.type,
    required this.title,
    this.fileName,
    this.url,
    required this.date,
    required this.status,
  });

  bool get hasFile => url != null && url!.isNotEmpty;
}

DocStatus _docStatusFromSlot(PharmacyVerificationDocStatus status) {
  return switch (status) {
    PharmacyVerificationDocStatus.verified => DocStatus.verified,
    PharmacyVerificationDocStatus.rejected => DocStatus.rejected,
    PharmacyVerificationDocStatus.pending => DocStatus.pending,
  };
}

class PharmacyVerificationPage extends ConsumerStatefulWidget {
  const PharmacyVerificationPage({super.key});

  @override
  ConsumerState<PharmacyVerificationPage> createState() =>
      _PharmacyVerificationPageState();
}

class _PharmacyVerificationPageState
    extends ConsumerState<PharmacyVerificationPage> {
  final Map<PharmacyVerificationDocType, bool> _uploading = {};
  final Map<PharmacyVerificationDocType, String?> _errors = {};

  List<VerificationDoc> _docsFromPharmacy(Pharmacy pharmacy) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final slotByKey = {
      for (final slot in resolveVerificationSlots(pharmacy))
        slot.slotKey: slot.document,
    };

    return PharmacyVerificationDocType.values.map((type) {
      final slotDoc =
          slotByKey[type.storageFolder] ?? const PharmacyVerificationDocument();
      final url = slotDoc.hasFile ? slotDoc.url : null;
      final date = slotDoc.uploadedAt != null
          ? dateFormat.format(slotDoc.uploadedAt!)
          : '';

      return VerificationDoc(
        type: type,
        title: type.title,
        fileName: url != null ? DocumentUrlUtils.fileNameFromUrl(url) : null,
        url: url,
        date: date,
        status: url != null
            ? _docStatusFromSlot(slotDoc.status)
            : DocStatus.pending,
      );
    }).toList();
  }

  Future<void> _replaceDocument(
    Pharmacy pharmacy,
    PharmacyVerificationDocType type, {
    PlatformFile? prePickedFile,
  }) async {
    setState(() {
      _uploading[type] = true;
      _errors[type] = null;
    });

    try {
      final uploadService = ref.read(documentUploadServiceProvider);
      final file = prePickedFile ?? await uploadService.pickDocument();
      if (file == null) {
        return;
      }

      final downloadUrl = await uploadService.uploadPlatformFile(
        file: file,
        storagePath:
            'pharmacies/${pharmacy.id}/verification/${type.storageFolder}',
      );

      final updated = applyVerificationSlotUpload(
        pharmacy: pharmacy,
        slotKey: type.storageFolder,
        downloadUrl: downloadUrl,
        contentType: DocumentUrlUtils.contentTypeFromFileName(file.name),
      );

      await ref.read(updatePharmacyInfoUseCaseProvider)(updated);
      ref.invalidate(currentPharmacyProvider);
      ref.invalidate(currentPharmacyStatusProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${type.title} uploaded successfully.')),
        );
      }
    } on DocumentUploadException catch (e) {
      setState(() => _errors[type] = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      setState(() => _errors[type] = 'Upload failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploading[type] = false);
      }
    }
  }

  Future<void> _deleteDocument(
    Pharmacy pharmacy,
    VerificationDoc doc,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Remove "${doc.fileName ?? doc.title}" from your pharmacy profile?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _uploading[doc.type] = true;
      _errors[doc.type] = null;
    });

    try {
      final updated = applyVerificationSlotDelete(
        pharmacy: pharmacy,
        slotKey: doc.type.storageFolder,
      );

      await ref.read(updatePharmacyInfoUseCaseProvider)(updated);
      ref.invalidate(currentPharmacyProvider);
      ref.invalidate(currentPharmacyStatusProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document removed.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploading[doc.type] = false);
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid document URL.')),
        );
      }
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open document.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open document: $e')),
        );
      }
    }
  }

  Future<void> _saveUrl(String url, String fileName) async {
    if (kIsWeb) {
      await _openUrl(url);
      return;
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final dir = await getApplicationDocumentsDirectory();
      final path = await writeBytesToDocuments(
        fileName: fileName,
        bytes: response.bodyBytes,
        directoryPath: dir.path,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  void _copyUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final pharmacyAsync = ref.watch(currentPharmacyProvider);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Pharmacy Verification'),
      body: pharmacyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load pharmacy: $e')),
        data: (pharmacy) {
          if (pharmacy == null) {
            return const Center(
              child: Text('No pharmacy linked to your account.'),
            );
          }

          final docs = _docsFromPharmacy(pharmacy);
          final pcnId = pharmacy.pcnRegistrationNumber?.trim();
          final pcnAgency = pharmacy.pcnAgency?.trim();

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.figmaWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBox(theme),
                SizedBox(height: context.figmaHeight(24)),
                ...docs.map(
                  (doc) => _buildDocCard(context, doc, pharmacy, theme),
                ),
                SizedBox(height: context.figmaHeight(16)),
                Text(
                  'PCN registration',
                  style: AppTextStyles.interP16M.copyWith(
                    color: theme.neutral.primaryText,
                  ),
                ),
                SizedBox(height: context.figmaHeight(16)),
                _buildReadOnlyField(
                  'PCN ID Number',
                  pcnId?.isNotEmpty == true ? pcnId! : 'Not provided',
                  theme,
                ),
                _buildReadOnlyField(
                  'Agency (State/Federal)',
                  pcnAgency?.isNotEmpty == true ? pcnAgency! : 'Not provided',
                  theme,
                ),
                SizedBox(height: context.figmaHeight(32)),
                KElevatedButton(
                  onPressed: _uploading[PharmacyVerificationDocType.additionalCert] ==
                          true
                      ? null
                      : () => _replaceDocument(
                            pharmacy,
                            PharmacyVerificationDocType.additionalCert,
                          ),
                  child: const Text('Upload more documents'),
                ),
                SizedBox(height: context.figmaHeight(40)),
              ],
            ),
          );
        },
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
    Pharmacy pharmacy,
    AppColorsTheme theme,
  ) {
    final isUploading = _uploading[doc.type] == true;
    final error = _errors[doc.type];
    final displayName = doc.fileName ?? 'No file uploaded';
    final isPdf = doc.hasFile && !DocumentUrlUtils.isImageUrl(doc.url);

    return Container(
      margin: EdgeInsets.only(bottom: context.figmaHeight(16)),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child: isUploading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        doc.hasFile && isPdf
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        color: doc.hasFile && isPdf
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
                      displayName,
                      style: AppTextStyles.interP14M.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      doc.hasFile
                          ? 'Updated ${doc.date}'
                          : 'Not uploaded yet',
                      style: AppTextStyles.interP12R.copyWith(
                        color: theme.neutral.tertiaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (doc.hasFile) _buildStatusBadge(doc.status, theme),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.interP12R.copyWith(color: theme.support.red),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (doc.hasFile)
                _buildActionText(
                  'View',
                  theme.support.blue,
                  () => _showViewModal(context, doc, theme),
                ),
              if (doc.hasFile)
                _buildActionText(
                  'Open',
                  theme.support.blue,
                  () => _openUrl(doc.url!),
                ),
              if (doc.hasFile && !kIsWeb)
                _buildActionText(
                  'Save',
                  theme.support.blue,
                  () => _saveUrl(
                    doc.url!,
                    doc.fileName ?? 'document',
                  ),
                ),
              if (doc.hasFile)
                _buildActionText(
                  'Copy link',
                  theme.support.blue,
                  () => _copyUrl(doc.url!),
                ),
              _buildActionText(
                doc.hasFile ? 'Replace' : 'Upload',
                theme.support.blue,
                isUploading
                    ? () {}
                    : () => _showReplaceModal(context, doc, pharmacy, theme),
              ),
              if (doc.hasFile)
                _buildActionText(
                  'Delete',
                  theme.support.red,
                  isUploading
                      ? () {}
                      : () => _deleteDocument(pharmacy, doc),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(DocStatus status, AppColorsTheme theme) {
    final (color, label) = switch (status) {
      DocStatus.verified => (theme.support.green, 'Verified'),
      DocStatus.rejected => (theme.support.red, 'Rejected'),
      DocStatus.pending => (theme.support.orange, 'Pending'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
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
    final url = doc.url;
    if (url == null) return;

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
                      doc.fileName ?? doc.title,
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
                constraints: const BoxConstraints(maxHeight: 280),
                width: double.infinity,
                color: theme.neutral.bgTint,
                child: DocumentUrlUtils.isImageUrl(url)
                    ? Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _pdfPlaceholder(theme),
                      )
                    : _pdfPlaceholder(theme),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _openUrl(url);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Open',
                      style: TextStyle(color: theme.support.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final pharmacy = ref.read(currentPharmacyProvider).value;
                      if (pharmacy != null) {
                        _showReplaceModal(context, doc, pharmacy, theme);
                      }
                    },
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

  Widget _pdfPlaceholder(AppColorsTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.picture_as_pdf, size: 48, color: theme.support.red),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Preview unavailable. Use Open to view the file.',
            textAlign: TextAlign.center,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  void _showReplaceModal(
    BuildContext context,
    VerificationDoc doc,
    Pharmacy pharmacy,
    AppColorsTheme theme,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _ReplaceDocumentDialog(
        doc: doc,
        pharmacy: pharmacy,
        theme: theme,
        onConfirm: (file) async {
          Navigator.pop(dialogContext);
          await _replaceDocument(pharmacy, doc.type, prePickedFile: file);
        },
      ),
    );
  }
}

class _ReplaceDocumentDialog extends ConsumerStatefulWidget {
  const _ReplaceDocumentDialog({
    required this.doc,
    required this.pharmacy,
    required this.theme,
    required this.onConfirm,
  });

  final VerificationDoc doc;
  final Pharmacy pharmacy;
  final AppColorsTheme theme;
  final Future<void> Function(PlatformFile file) onConfirm;

  @override
  ConsumerState<_ReplaceDocumentDialog> createState() =>
      _ReplaceDocumentDialogState();
}

class _ReplaceDocumentDialogState extends ConsumerState<_ReplaceDocumentDialog> {
  PlatformFile? _pendingFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Dialog(
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
                Text(
                  widget.doc.hasFile
                      ? 'Replace Document'
                      : 'Upload Document',
                  style: AppTextStyles.interP16M,
                ),
                IconButton(
                  onPressed: _isUploading
                      ? null
                      : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.doc.title, style: AppTextStyles.interP14M),
            const SizedBox(height: 12),
            Text(
              'Required: JPG, PNG, PDF — max 5 MB',
              style: AppTextStyles.interP14R.copyWith(
                color: theme.neutral.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            DocumentPickPreviewField(
              label: widget.doc.title,
              file: _pendingFile,
              onPick: (file) => setState(() => _pendingFile = file),
              onRemove: () => setState(() => _pendingFile = null),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isUploading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.support.blue),
                  ),
                ),
                TextButton(
                  onPressed: _pendingFile == null || _isUploading
                      ? null
                      : () async {
                          setState(() => _isUploading = true);
                          try {
                            await widget.onConfirm(_pendingFile!);
                          } finally {
                            if (mounted) {
                              setState(() => _isUploading = false);
                            }
                          }
                        },
                  child: _isUploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.doc.hasFile ? 'Upload' : 'Upload',
                          style: TextStyle(color: theme.support.blue),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
