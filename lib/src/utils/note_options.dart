import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapit/src/models/note.dart';
import 'package:mapit/src/utils/save_note_options.dart';
import 'package:mapit/src/views/create_note/create_note_view.dart';
import 'package:mapit/src/views/home/home_view.dart';
import 'package:share_plus/share_plus.dart';

import '../models/task.dart';
import '../provider/note_provider.dart';

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
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  print('delete button clicked');
                  noteProvider.deleteNoteAndNavigate(context,note.noteId);
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
