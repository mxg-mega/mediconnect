import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/provider/file_zone_provider.dart';

void onBrowse(BuildContext context, WidgetRef ref) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png', 'pdf'],
  );

  if (result == null) return;

  final file = result.files.single;

  ref.read(fileUploadProvider.notifier).pickFile(
        name: file.name,
        sizeInBytes: file.size,
      );
}
