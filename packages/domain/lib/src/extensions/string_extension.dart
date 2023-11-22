/// An extension on nullable string
extension StringExtension on String? {
  ///
  bool get isNullOrWhiteSpace =>
      this == null || this!.isEmpty || this!.trim().isEmpty;

  ///
  bool get isNotNullOrWhiteSpace =>
      this != null && this!.isNotEmpty && this!.trim().isNotEmpty;
}
