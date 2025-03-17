class Task {
  String _text;
  bool _isCompleted;

  // Getters
  String get text => _text;
  bool get isCompleted => _isCompleted;

  // Setters
  set text(String newText) {
    _text = newText;
  }

  set isCompleted(bool completed) {
    _isCompleted = completed;
  }

  Task({
    required String text,
    bool isCompleted = false,
  }) : 
    _text = text,
    _isCompleted = isCompleted;

  Task copyWith({
    String? text,
    bool? isCompleted,
  }) {
    return Task(
      text: text ?? this._text,
      isCompleted: isCompleted ?? this._isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      text: json['text'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': _text,
      'isCompleted': _isCompleted,
    };
  }
}
