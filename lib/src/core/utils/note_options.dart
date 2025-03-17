import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapit/src/core/utils/save_note_options.dart';
import 'package:mapit/src/domain/entities/note.dart';
import 'package:mapit/src/domain/entities/task.dart';
import 'package:mapit/src/presentation/providers/note_provider.dart';
import 'package:share_plus/share_plus.dart';

class ActionButtonUtils {
  static void backButtonAction(BuildContext context, TextEditingController titleController, TextEditingController descriptionController, List<Task> tasks, Note? note, String address, LocationData locationData) {
    Navigator.pop(context);
    NoteUtils.saveNote(context, titleController, descriptionController, tasks, note, address, locationData);
  }

  static void shareButtonAction(String content) {
    Share.share(content);
  }

  static void pinButtonAction(Note note, NoteProvider noteProvider) async {
    note.isPinned = !note.isPinned;
    noteProvider.updateNote(noteProvider.notes.indexWhere((n) => n.noteId == note.noteId), note);

    // NoteUtils.saveNote(note);
  }

  static Future<void> showOptions(BuildContext context, NoteProvider noteProvider, Note note) async {
    print("show_options clicked");
    Option? result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_alarm_outlined),
                title: Text('Time Reminder'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      DateTime finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      note.reminderTime = finalDateTime;
                      noteProvider.updateNote(noteProvider.notes.indexWhere((n) => n.noteId == note.noteId), note);
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(note.isSilent ? Icons.volume_off : Icons.volume_up),
                title: Text('Silent'),
                onTap: () {
                  note.isSilent = !note.isSilent;
                  noteProvider.updateNote(noteProvider.notes.indexWhere((n) => n.noteId == note.noteId), note);
                },
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      switch (result) {
        case Option.Edit:
        // Add functionality for edit option
          break;
        case Option.Delete:
          noteProvider.deleteNoteAndNavigate(context, note.noteId);
          break;
      }
    }
  }
}

enum Option { Edit, Delete }
