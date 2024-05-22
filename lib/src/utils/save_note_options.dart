import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:mapit/src/models/note.dart';
import 'package:mapit/src/provider/note_provider.dart';
import '../models/task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NoteUtils {
  static String saveNote(BuildContext context, TextEditingController titleController, TextEditingController descriptionController, List<Task> tasks, Note? note, String address, LocationData locationData) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    print('NoteUtils.saveNote: ${locationData.latitude} ${locationData.longitude}');

    final newNote = Note(
      noteId: note?.noteId ?? DateTime.now().toString(),
      title: titleController.text,
      description: descriptionController.text,
      taskList: tasks,
      latitude: locationData.latitude ?? 0.0,
      longitude: locationData.longitude ?? 0.0,
      address: address ,
      label: note?.label ?? 'moderate',
      isPinned: note?.isPinned ?? false,
    );

    final existingNoteIndex = noteProvider.notes.indexWhere((n) => n.noteId == newNote.noteId);

    if (existingNoteIndex != -1) {
      final updatedNote = _updateNoteProperties(noteProvider.notes[existingNoteIndex], newNote);

      noteProvider.updateNote(existingNoteIndex, updatedNote);
      print('Note updated: ${updatedNote.title}');
    } else {
      if (newNote.title!.isNotEmpty || newNote.description!.isNotEmpty) {
        noteProvider.addNote(newNote);
        print('Note saved: ${newNote.title}');
      } else {
        print('Note not saved: Title and description are empty');
      }
    }

    return newNote.noteId;
  }

  static Note _updateNoteProperties(Note existingNote, Note newNote) {
    print('NoteUtils._updateNoteProperties: ${newNote.latitude} ${newNote.longitude}' );
    return Note(
      noteId: existingNote.noteId,
      title: newNote.title,
      description: newNote.description,
      taskList: newNote.taskList,
      latitude: existingNote.latitude,
      longitude: existingNote.longitude,
      address: existingNote.address,
      label: existingNote.label,
      isPinned: newNote?.isPinned ?? false,
    );
  }

  static void addNewTask(List<Task> tasks, Function setState) {
    tasks.add(Task(text: '', isCompleted: false));
    setState(() {});
  }

  static void updateNoteLocation(BuildContext context, String noteId, String address, LatLng locationData) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    final noteIndex = noteProvider.notes.indexWhere((note) => note.noteId == noteId);
    print("THE DATAAAAAAAAAAAAAAA..............${locationData.latitude}");
    print(locationData.longitude);
    if (noteIndex != -1) {
      noteProvider.notes[noteIndex].latitude = locationData.latitude;
      noteProvider.notes[noteIndex].longitude = locationData.longitude;
      print('location ${locationData.longitude}');
      noteProvider.notes[noteIndex].address = address;
      noteProvider.updateNote(noteIndex, noteProvider.notes[noteIndex]);
      print('Note location updated: ${noteProvider.notes[noteIndex].title}');
    } else {
      print('Note not found: $noteId');
    }
  }

  static void updateNotePriority(BuildContext context, String noteId, int priorityLevel) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    final noteIndex = noteProvider.notes.indexWhere((note) => note.noteId == noteId);

    if (noteIndex != -1) {
      switch (priorityLevel) {
        case 0:
          noteProvider.notes[noteIndex].label = 'low';
          break;
        case 1:
          noteProvider.notes[noteIndex].label = 'moderate';
          break;
        case 2:
          noteProvider.notes[noteIndex].label = 'high';
          break;
      }
      noteProvider.updateNote(noteIndex, noteProvider.notes[noteIndex]);
      print('Note priority updated: ${noteProvider.notes[noteIndex].label}');
    } else {
      print('Note not found: $noteId');
    }
  }
}
