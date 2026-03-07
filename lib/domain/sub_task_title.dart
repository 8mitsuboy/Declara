class SubTaskTitle {
  final String value;
  SubTaskTitle._({required this.value});

  static const int _maxLength = 100;

  factory SubTaskTitle(String title) {
    if (title.isEmpty) throw FormatException("Title must not be empty");
    if (title.length > _maxLength) throw FormatException("Title too long");
    return SubTaskTitle._(value: title);
  }
}
