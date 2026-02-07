import 'package:flutter/material.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/dashed_border_container.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/upload_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class FileDropZone extends StatelessWidget {
  final VoidCallback onBrowse;
  final String hintText;
  final String fileInfoText;

  const FileDropZone({
    super.key,
    required this.onBrowse,
    this.hintText = "Drag and drop files here",
    this.fileInfoText = "Required: JPG, PNG, PDF - max 5MB",
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return DashedBorderContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: theme.neutral.secondaryText,
          ),
          const SizedBox(height: 16),

          Text(
            hintText,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            "OR",
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),

          const SizedBox(height: 12),

          UploadButton(text: "Browse Files", onPressed: onBrowse),

          const SizedBox(height: 16),

          Text(
            fileInfoText,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
