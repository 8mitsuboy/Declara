class DeclarationTitle {
  final String value;
  DeclarationTitle._({required this.value});

  static const int _maxLength = 30;

  factory DeclarationTitle(String title) {
    if (title.isEmpty) throw FormatException("Title must not be empty");
    if (title.length > _maxLength) throw FormatException("Title too long");
    return DeclarationTitle._(value: title);
  }
}
