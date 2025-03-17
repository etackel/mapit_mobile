import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapit/src/domain/entities/note.dart';
import 'package:mapit/src/domain/entities/task.dart';
import 'package:mapit/src/presentation/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class NoteUtils {
  static final Logger _logger = Logger();

  static void addNewTask(List<Task> tasks, StateSetter setState) {
    setState(() {
      tasks.add(Task(text: '', isCompleted: false));
    });
  }

  static String saveNote(
    BuildContext context, 
    TextEditingController titleController, 
    TextEditingController descriptionController, 
    List<Task> tasks, 
    Note? existingNote, 
    String address, 
    LocationData locationData
  ) {
    try {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      
      if (titleController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter a title');
        return '';
      }

      final note = Note(
        noteId: existingNote?.noteId ?? '',
        title: titleController.text,
        description: descriptionController.text,
        taskList: tasks,
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
        address: address,
        isPinned: existingNote?.isPinned ?? false,
        reminderTime: existingNote?.reminderTime ?? DateTime.now(),
        isSilent: existingNote?.isSilent ?? false,
      );

      String savedNoteId;
      if (existingNote == null) {
        savedNoteId = note.noteId;
        noteProvider.addNote(note);
      } else {
        int noteIndex = noteProvider.notes.indexWhere((n) => n.noteId == existingNote.noteId);
        if (noteIndex != -1) {
          noteProvider.updateNote(noteIndex, note);
        }
        savedNoteId = note.noteId;
      }

      Fluttertoast.showToast(msg: 'Note saved successfully');
      return savedNoteId;
    } catch (e) {
      _logger.e('Error saving note: $e');
      Fluttertoast.showToast(msg: 'Error saving note: $e');
      return '';
    }
  }

  static void _updateNoteField(BuildContext context, String noteId, Function(Note) updateFunction) {
    try {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final noteIndex = noteProvider.notes.indexWhere((note) => note.noteId == noteId);
      if (noteIndex != -1) {
        updateFunction(noteProvider.notes[noteIndex]);
        noteProvider.updateNote(noteIndex, noteProvider.notes[noteIndex]);
      } else {
        _logger.e('Note not found: $noteId');
      }
    } catch (e) {
      _logger.e('Error updating note: $e');
    }
  }

  static void updateNoteLocation(BuildContext context, String noteId, String address, LatLng locationData) {
    _updateNoteField(context, noteId, (note) {
      note.latitude = locationData.latitude;
      note.longitude = locationData.longitude;
      note.address = address;
      _logger.i('Note location updated: ${note.title}');
    });
  }

  static void updateNotePriority(BuildContext context, String noteId, int priorityLevel) {
    _updateNoteField(context, noteId, (note) {
      switch (priorityLevel) {
        case 0:
          note.label = 'low';
          break;
        case 1:
          note.label = 'moderate';
          break;
        case 2:
          note.label = 'high';
          break;
      }
      _logger.i('Note priority updated: ${note.label}');
    });
  }
}
