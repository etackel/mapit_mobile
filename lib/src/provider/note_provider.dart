import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/task.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  // Getter for notes
  List<Note> get notes => _notes;

  // Method to add a new note
  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  // Method to update an existing note
  void updateNote(int index, Note updatedNote) {
    _notes[index] = updatedNote;
    notifyListeners();
  }

  // Method to delete a note
  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  // Method to add or update tasks for a note
  void saveTasks(Note note, List<Task> tasks) {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);

    // Check if the note exists in the list
    if (index != -1) {
      // Update the tasks for the existing note
      _notes[index].taskList = tasks;
      notifyListeners();
    }
  }
}
