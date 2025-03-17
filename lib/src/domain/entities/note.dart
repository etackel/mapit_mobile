import 'package:mapit/src/domain/entities/task.dart';

class Note {
  final String noteId;
  final String title;
  final String description;
  final List<Task> taskList;
  double latitude;
  double longitude;
  String address;
  String? label;
  bool isPinned;
  DateTime reminderTime;
  bool isSilent;

  Note({
    required this.noteId,
    required this.title,
    this.description = '',
    this.taskList = const [],
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.address = '',
    this.label,
    required this.isPinned,
    required this.reminderTime,
    required this.isSilent,
  });

  Note copyWith({
    String? noteId,
    String? title,
    String? description,
    List<Task>? taskList,
    double? latitude,
    double? longitude,
    String? address,
    String? label,
    bool? isPinned,
    DateTime? reminderTime,
    bool? isSilent,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      description: description ?? this.description,
      taskList: taskList ?? this.taskList,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      label: label ?? this.label,
      isPinned: isPinned ?? this.isPinned,
      reminderTime: reminderTime ?? this.reminderTime,
      isSilent: isSilent ?? this.isSilent,
    );
  }

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
      reminderTime: DateTime.parse(json['reminderTime']),
      isSilent: json['isSilent'] ?? false,
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
      'isPinned': isPinned,
      'reminderTime': reminderTime.toIso8601String(),
      'isSilent': isSilent,
    };
  }
}
