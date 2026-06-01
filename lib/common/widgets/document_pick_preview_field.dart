import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/services/document_upload_service.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

/// Picks a document and shows a local preview before upload (signup / profile pick flows).
class DocumentPickPreviewField extends ConsumerStatefulWidget {
  const DocumentPickPreviewField({
    super.key,
    required this.label,
    required this.file,
    required this.onPick,
    this.onRemove,
  });

  final String label;
  final PlatformFile? file;
  final void Function(PlatformFile file) onPick;
  final VoidCallback? onRemove;

  @override
  ConsumerState<DocumentPickPreviewField> createState() =>
      _DocumentPickPreviewFieldState();
}

class _DocumentPickPreviewFieldState
    extends ConsumerState<DocumentPickPreviewField> {
  bool _isPicking = false;
  String? _error;

  bool _isImage(PlatformFile file) {
    final name = file.name.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png');
  }

  bool _isPdf(PlatformFile file) {
    return file.name.toLowerCase().endsWith('.pdf');
  }

  Future<void> _pick() async {
    setState(() {
      _isPicking = true;
      _error = null;
    });
    try {
      final uploadService = ref.read(documentUploadServiceProvider);
      final file = await uploadService.pickDocument();
      if (file != null) {
        widget.onPick(file);
      }
    } on DocumentUploadException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Failed to pick file: $e');
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _openFullPreview(PlatformFile file) {
    final theme = AppTheme.colors(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      file.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isImage(file) && file.bytes != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: Image.memory(file.bytes!, fit: BoxFit.contain),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.picture_as_pdf, size: 48, color: theme.support.red),
                      const SizedBox(height: 8),
                      Text(file.name, textAlign: TextAlign.center),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final file = widget.file;

    return LabeledInput(
      label: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (file == null)
            OutlinedButton(
              onPressed: _isPicking ? null : _pick,
              child: _isPicking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Choose file'),
            )
          else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.neutral.bgTint,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.neutral.border.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isImage(file) && file.bytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        file.bytes!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Icon(
                      _isPdf(file) ? Icons.picture_as_pdf : Icons.insert_drive_file,
                      size: 40,
                      color: theme.pharmacist.bg,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isPdf(file) ? 'PDF selected' : 'Image selected',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.neutral.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                TextButton(
                  onPressed: _isPicking ? null : _pick,
                  child: const Text('Change'),
                ),
                TextButton(
                  onPressed: () => _openFullPreview(file),
                  child: const Text('Preview'),
                ),
                if (widget.onRemove != null)
                  TextButton(
                    onPressed: widget.onRemove,
                    child: Text(
                      'Remove',
                      style: TextStyle(color: theme.support.red),
                    ),
                  ),
              ],
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 4),
            Text(
              _error!,
              style: TextStyle(color: theme.support.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
