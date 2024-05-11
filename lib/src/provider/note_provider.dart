import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../models/task.dart';
import '../views/home/home_view.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [

  ];

  List<Note> _filteredNotes = [

  ];


  // SharedPreferences key
  static const String _notesKey = 'notes';

  // Constructor
  NoteProvider() {
    // Load notes from SharedPreferences when the app starts
    _loadNotes();
  }

  // Getter for notes
  List<Note> get notes => _notes;
  List<Note> get filteredNotes => _filteredNotes;


  // Method to add a new note
  void addNote(Note note) {
    _notes.add(note);
    _saveNotes(); // Save notes to SharedPreferences
    notifyListeners();
  }

  // Method to update an existing note
  void updateNote(int index, Note updatedNote) {
    print('Note updated: ${updatedNote.title}');
    _notes[index] = updatedNote;
    _saveNotes();
    notifyListeners();
  }

  // Method to delete a note
  void deleteNote(int index) {
    _notes.removeAt(index);
    _saveNotes();
    notifyListeners();
  }

  void _saveNotes() async {
    print('Saving notes in SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesJson = jsonEncode(_notes.map((note) => note.toJson()).toList());
    await prefs.setString(_notesKey, notesJson);
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesJson = prefs.getString(_notesKey);
    if (notesJson != null) {
      Iterable decoded = jsonDecode(notesJson);
      _notes = decoded.map((json) => Note.fromJson(json)).toList();
      notifyListeners();
    }
  }

  // Method to add or update tasks for a note
  void saveTasks(Note note, List<Task> tasks) {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);

    // Check if the note exists in the list
    if (index != -1) {
      // Update the tasks for the existing note
      _notes[index].taskList = tasks;
      _saveNotes(); // Save notes to SharedPreferences
      notifyListeners();
    }
  }

  void searchNotes(String searchText) {
    if (searchText.isEmpty) {
      // If search text is empty, show all notes
      _filteredNotes = List.from(_notes);
    } else {
      // Filter notes based on search text
      _filteredNotes = _notes.where((note) {
        // You can customize this condition based on your requirements
        return note.title.toLowerCase().contains(searchText.toLowerCase()) ||
            note.description.toLowerCase().contains(searchText.toLowerCase()) ||
            note.taskList.any((task) => task.text.toLowerCase().contains(searchText.toLowerCase()));
      }).toList();
    }
    notifyListeners();
  }

  // Method to delete a note by ID
  void deleteNoteById(String noteId) {
    print('Deleting note with ID: $noteId');
    int index = _notes.indexWhere((note) => note.noteId == noteId);
    if (index != -1) {
      _notes.removeAt(index);
      _saveNotes();
      notifyListeners();
    }
  }

  void deleteNoteAndNavigate(BuildContext context, String noteId) {
    deleteNoteById(noteId);

    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }



}
