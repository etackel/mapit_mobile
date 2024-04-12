import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/task.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [
    Note(
      noteId: '1',
      title: 'Grocery Shopping',
      description: 'Buy milk, eggs, and bread',
      latitude: 36.2509,
      longitude: 88.1694,
      taskList: [
        Task(text: 'Buy milk',isCompleted: true),
        Task(text: 'Buy eggs',isCompleted: false),
        Task(text: 'Buy bread',isCompleted: true),
      ],
      address: '123 Main St, San Francisco, CA',
    ),
    Note(
      noteId: '2',
      title: 'Meeting at Work',
      description: 'Discuss project updates at 2 PM',
      latitude: 37.780,
      longitude: -122.420,
      taskList: [
        Task(text: 'Prepare project presentation', isCompleted: false),
        Task(text: 'Review project documents', isCompleted: true),
        Task(text: 'Meet with team at 2 PM', isCompleted: false),
      ],
      address: '456 Market St, San Francisco, CA',
    ),
  ];


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
