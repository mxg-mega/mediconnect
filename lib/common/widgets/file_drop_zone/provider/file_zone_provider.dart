import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/file_drop_zone/model/selected_file.dart';

final fileUploadProvider =
    StateNotifierProvider<FileUploadNotifier, SelectedFile?>(
  (ref) => FileUploadNotifier(),
);

class FileUploadNotifier extends StateNotifier<SelectedFile?> {
  FileUploadNotifier() : super(null);

  void pickFile({
    required String name,
    required int sizeInBytes,
  }) {
    state = SelectedFile(
      name: name,
      sizeInBytes: sizeInBytes,
    );
  }

  void clear() {
    state = null;
  }
}
