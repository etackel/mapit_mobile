import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/note.dart';
import '../../../provider/note_provider.dart';
import '../../create_note/create_note_view.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final NoteProvider noteProvider = NoteProvider();

  TopBar({required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          Expanded(
            child: Container(
              height: 24,
              color: Colors.white,
              child: Center(
                child: Text(
                  'MapIT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchDelegateExample(noteProvider: noteProvider));
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}

class SearchDelegateExample extends SearchDelegate<String> {
  final NoteProvider noteProvider;

  SearchDelegateExample({required this.noteProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build search results based on the query
    return _buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Build search suggestions based on the query (optional)
    return _buildSearchResults(context, query);
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    // Filter notes based on the search query
    List<Note> filteredNotes = noteProvider.notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNoteScreen(
                        note: filteredNotes[index],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(filteredNotes[index].title),
                  subtitle: Text(filteredNotes[index].description),
                  // Add more fields of the note as needed
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
