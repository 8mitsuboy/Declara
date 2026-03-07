class TaskTitle {
  final String value;
  TaskTitle._({required this.value});

  static const int _maxLength = 100;

  factory TaskTitle(String title) {
    if (title.isEmpty) throw FormatException("Title must not be empty");
    if (title.length > _maxLength) throw FormatException("Title too long");
    return TaskTitle._(value: title);
  }
}
