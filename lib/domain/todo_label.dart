class TodoLabel {
  final String value;
  TodoLabel._({required this.value});

  static const int _maxLength = 30;

  factory TodoLabel(String label) {
    if (label.isEmpty) throw FormatException("Label must not be empty");
    if (label.length < _maxLength) throw FormatException("Label too long");
    return TodoLabel._(value: label);
  }
}
