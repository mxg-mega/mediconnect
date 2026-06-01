import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;

class DocumentUploadException implements Exception {
  final String message;
  const DocumentUploadException(this.message);

  @override
  String toString() => message;
}

class DocumentUploadService {
  DocumentUploadService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static const int maxFileSizeBytes = 5 * 1024 * 1024;
  static const Set<String> allowedExtensions = {'jpg', 'jpeg', 'png', 'pdf'};

  Future<PlatformFile?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions.toList(),
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    _validateFile(file);
    return file;
  }

  void _validateFile(PlatformFile file) {
    final ext = _extension(file.name);
    if (!allowedExtensions.contains(ext)) {
      throw DocumentUploadException(
        'Allowed file types: JPG, PNG, PDF',
      );
    }
    if (file.size > maxFileSizeBytes) {
      throw DocumentUploadException('File must be 5 MB or smaller');
    }
    if (file.bytes == null && file.path == null) {
      throw DocumentUploadException('Could not read the selected file');
    }
  }

  String _extension(String name) {
    final dot = name.lastIndexOf('.');
    if (dot < 0) return '';
    return name.substring(dot + 1).toLowerCase();
  }

  Future<Uint8List> _prepareBytes(PlatformFile file) async {
    Uint8List bytes;
    if (file.bytes != null) {
      bytes = file.bytes!;
    } else if (file.path != null) {
      throw DocumentUploadException(
        'File bytes unavailable. Re-select the file.',
      );
    } else {
      throw DocumentUploadException('Could not read the selected file');
    }

    final ext = _extension(file.name);
    if (ext == 'pdf') return bytes;

    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;

    final resized = img.copyResize(
      decoded,
      width: decoded.width > 1920 ? 1920 : decoded.width,
    );
    return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  }

  String _contentType(String fileName) {
    final ext = _extension(fileName);
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      default:
        return 'image/jpeg';
    }
  }

  String _storageFileName(String originalName) {
    final ext = _extension(originalName);
    if (ext == 'pdf') return originalName;
    final base = originalName.contains('.')
        ? originalName.substring(0, originalName.lastIndexOf('.'))
        : originalName;
    return '$base.jpg';
  }

  Future<String> uploadPlatformFile({
    required PlatformFile file,
    required String storagePath,
  }) async {
    _validateFile(file);
    final bytes = await _prepareBytes(file);
    if (bytes.length > maxFileSizeBytes) {
      throw DocumentUploadException(
        'Compressed file still exceeds 5 MB. Choose a smaller image.',
      );
    }

    final ref = _storage.ref('$storagePath/${_storageFileName(file.name)}');
    await ref.putData(
      bytes,
      SettableMetadata(contentType: _contentType(file.name)),
    );
    return ref.getDownloadURL();
  }
}
