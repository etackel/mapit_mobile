// models/task.dart

class Task {
  final String text;
  late final bool isCompleted;

  Task({
    required this.text,
    this.isCompleted = false, // Default isCompleted to false
  });
}
