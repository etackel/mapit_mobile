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


  static const String _notesKey = 'notes';

  NoteProvider() {
    _loadNotes();
  }

  List<Note> get notes => _notes;
  List<Note> get filteredNotes => _filteredNotes;


  void addNote(Note note) {
    _notes.add(note);
    _saveNotes();
    notifyListeners();
  }

  void updateNote(int index, Note updatedNote) {
    print('Note updated: ${updatedNote.title}');
    _notes[index] = updatedNote;
    _saveNotes();
    notifyListeners();
  }

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

  void saveTasks(Note note, List<Task> tasks) {
    int index = _notes.indexOf(note);

    if (index != -1) {
      _notes[index].taskList = tasks;
      _saveNotes();
      notifyListeners();
    }
  }

  void searchNotes(String searchText) {
    if (searchText.isEmpty) {
      _filteredNotes = List.from(_notes);
    } else {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(searchText.toLowerCase()) ||
            note.description.toLowerCase().contains(searchText.toLowerCase()) ||
            note.taskList.any((task) => task.text.toLowerCase().contains(searchText.toLowerCase()));
      }).toList();
    }
    notifyListeners();
  }

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
