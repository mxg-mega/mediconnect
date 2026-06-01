import 'local_file_writer_io.dart'
    if (dart.library.html) 'local_file_writer_stub.dart';

Future<String> writeBytesToDocuments({
  required String fileName,
  required List<int> bytes,
  required String directoryPath,
}) {
  return writeBytesToDocumentsImpl(
    fileName: fileName,
    bytes: bytes,
    directoryPath: directoryPath,
  );
}
