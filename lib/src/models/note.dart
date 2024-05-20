import 'package:mapit/src/models/task.dart';

class Note {
  String noteId;
  String title;
  String description;
  double latitude;
  double longitude;
  List<Task> taskList;
  String address;
  String? label;
  bool isPinned;

  Note({
    required this.noteId,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.taskList,
    required this.address,
    this.label,
    required this.isPinned ,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      taskList: List<Task>.from(json['taskList'].map((taskJson) => Task.fromJson(taskJson))),
      address: json['address'],
      label: json['label'],
      isPinned: json['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'taskList': taskList.map((task) => task.toJson()).toList(),
      'address': address,
      'label': label,
      'isPinned': isPinned, // Include isPinned in JSON
    };
  }
}
