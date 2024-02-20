import 'package:mapit/src/models/task.dart';

class Note {
  final String? noteId;
  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  late final List<Task>? taskList;
  final String? label;

  final String? address;

  Note({
    this.noteId,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.taskList,
    this.label,
    this.address,
  });
}
