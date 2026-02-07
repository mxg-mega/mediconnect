class SelectedFile {
  final String name;
  final int sizeInBytes;

  const SelectedFile({
    required this.name,
    required this.sizeInBytes,
  });

  String get sizeLabel {
    final mb = sizeInBytes / (1024 * 1024);
    return "${mb.toStringAsFixed(1)} MB";
  }
}
