import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapit/src/utils/save_note_options.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../provider/note_provider.dart';
import '../../../utils/note_options.dart';
import '../../../models/note.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<Task> tasks;
  final Note? note;
  final String address;
  final LocationData locationData;

  TopBar(this.titleController, this.descriptionController, this.tasks, this.note, this.address, this.locationData);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(70.0);
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              ActionButtonUtils.backButtonAction(context, widget.titleController, widget.descriptionController, widget.tasks, widget.note, widget.address, widget.locationData);
            },
          ),
          Expanded(
            child: Container(
              height: 25,
              color: Colors.white, 
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  final noteContent = _buildNoteContent(widget.titleController.text, widget.descriptionController.text, widget.tasks);
                  ActionButtonUtils.shareButtonAction(noteContent);
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: (widget.note != null && widget.note!.isPinned)
                    ? Icon(Icons.push_pin)
                    : Icon(Icons.push_pin_outlined),
                onPressed: () {
                  if (widget.note != null) {
                    ActionButtonUtils.pinButtonAction(widget.note!, context.read<NoteProvider>());
                    setState(() {});
                  }
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  print('more_vert clicked');
                  context.read<NoteProvider>().deleteNoteById(widget.note!.noteId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildNoteContent(String title, String description, List<Task> tasks) {
    final StringBuffer contentBuffer = StringBuffer();

    // Add title
    contentBuffer.writeln('Title: $title');

    // Add description
    contentBuffer.writeln('Description: $description');

    // Add tasks
    if (tasks.isNotEmpty) {
      contentBuffer.writeln('Tasks:');
      for (final task in tasks) {
        contentBuffer.writeln('- ${task.text}');
      }
    }

    return contentBuffer.toString();
  }
}
