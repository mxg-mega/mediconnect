import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/dashed_border_container.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/model/selected_file.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/provider/file_zone_provider.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/upload_button.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class FileUploadCard extends ConsumerWidget {
  final VoidCallback onBrowse;

  const FileUploadCard({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(fileUploadProvider);

    return DashedBorderContainer(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: file == null
            ? _EmptyState(onBrowse: onBrowse)
            : _FileSelectedState(file: file, onBrowse: onBrowse),
      ),
    );
  }
}

class _FileSelectedState extends StatelessWidget {
  final SelectedFile file;
  final VoidCallback onBrowse;

  const _FileSelectedState({required this.file, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SVG goes here
        Container(
          decoration: BoxDecoration(
            color: AppTheme.colors(context).neutral.bgTint,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 56,
          child: SvgPicture.asset(AppIcons.image88, height: 56, width: 56),
        ),

        const SizedBox(height: 12),

        Text(file.name, style: Theme.of(context).textTheme.bodyMedium),

        const SizedBox(height: 4),

        Text(
          file.sizeLabel,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.black54),
        ),

        const SizedBox(height: 16),

        UploadButton(text: "Browse Files", onPressed: onBrowse),

        const SizedBox(height: 16),
        const Text("Required: JPG, PNG, PDF - max 5MB"),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptyState({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppIcons.uploadCloud, height: 48, width: 48),

        const SizedBox(height: 16),
        const Text("Drag and drop files here"),
        const SizedBox(height: 8),
        const Text("OR"),
        const SizedBox(height: 12),

        UploadButton(text: "Browse Files", onPressed: onBrowse),

        const SizedBox(height: 16),
        const Text("Required: JPG, PNG, PDF - max 5MB"),
      ],
    );
  }
}
