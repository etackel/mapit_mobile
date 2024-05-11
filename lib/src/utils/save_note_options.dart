import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:mapit/src/models/note.dart';
import 'package:mapit/src/provider/note_provider.dart';
import '../models/task.dart';

class NoteUtils {
  static void saveNote(BuildContext context, TextEditingController titleController, TextEditingController descriptionController, List<Task> tasks, Note? note, String address, LocationData locationData) {
    print('calling save note');
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);


    final newNote = Note(
      noteId: note?.noteId ?? DateTime.now().toString(),
      title: titleController.text,
      description: descriptionController.text,
      taskList: tasks,
      latitude: locationData.latitude ?? 0.0,
      longitude: locationData.longitude ?? 0.0,
      address: address ?? 'example address',
      label: 'moderate',
      isPinned: note?.isPinned ?? false,
    );

    // Check if a note with the same noteId already exists
    final existingNoteIndex = noteProvider.notes.indexWhere((n) => n.noteId == newNote.noteId);

    if (existingNoteIndex != -1) {
      // Update the existing note
      final updatedNote = _updateNoteProperties(noteProvider.notes[existingNoteIndex], newNote);

      noteProvider.updateNote(existingNoteIndex, updatedNote);
      print('Note updated: ${updatedNote.title}');
    } else {
      // Add the new note
      if (newNote.title!.isNotEmpty || newNote.description!.isNotEmpty) {
        noteProvider.addNote(newNote);
        print('Note saved: ${newNote.title}');
      } else {
        print('Note not saved: Title and description are empty');
      }
    }
  }

  static Note _updateNoteProperties(Note existingNote, Note newNote) {
    return Note(
      noteId: existingNote.noteId,
      title: newNote.title,
      description: newNote.description,
      taskList: newNote.taskList,
      latitude: newNote.latitude,
      longitude: newNote.longitude,
      address: newNote.address,
      label: newNote.label,
      isPinned: newNote?.isPinned ?? false,
    );
  }

  static void addNewTask(List<Task> tasks, Function setState) {
    tasks.add(Task(text: '', isCompleted: false));
    setState(() {});
  }
}
