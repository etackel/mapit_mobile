import 'package:flutter/material.dart';
import 'package:mapit/src/utils/save_note.dart';
import 'package:mapit/src/models/note.dart';
import '../../../models/task.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<Task> tasks;
  final Note? note;

  TopBar(this.titleController, this.descriptionController, this.tasks, this.note);
  @override
  Size get preferredSize => Size.fromHeight(70.0);

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
              Navigator.pop(context);
              NoteUtils.saveNote(context, titleController,
                  descriptionController, tasks, note);
            },
          ),
          Expanded(
            child: Container(
              height: 25,
              color: Colors.white, // Adjust the color if needed
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Add functionality for notification button
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.push_pin_outlined),
                onPressed: () {
                  // Add functionality for mail button
                },
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Add functionality for settings button
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
