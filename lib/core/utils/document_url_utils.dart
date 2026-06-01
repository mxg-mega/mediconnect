/// Utilities for document URLs from Firebase Storage.
class DocumentUrlUtils {
  DocumentUrlUtils._();

  static bool isImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.contains('.jpg?') ||
        lower.contains('.jpeg?') ||
        lower.contains('.png?');
  }

  static String contentTypeFromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.png')) return 'image/png';
    return 'image/jpeg';
  }

  static String fileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return 'Document';
    final segments = uri.pathSegments;
    if (segments.isEmpty) return 'Document';
    return Uri.decodeComponent(segments.last);
  }
}
