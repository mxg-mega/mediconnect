import 'dart:io';

Future<String> writeBytesToDocumentsImpl({
  required String fileName,
  required List<int> bytes,
  required String directoryPath,
}) async {
  final safeName = fileName.replaceAll(RegExp(r'[^\w.\-]'), '_');
  final file = File('$directoryPath/$safeName');
  await file.writeAsBytes(bytes);
  return file.path;
}
