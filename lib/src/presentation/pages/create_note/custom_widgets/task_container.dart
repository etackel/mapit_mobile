import 'package:flutter/material.dart';
import 'package:mapit/src/domain/entities/task.dart';
import 'package:mapit/src/core/utils/save_note_options.dart';
import 'package:mapit/src/domain/entities/note.dart';

class TaskContainer extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<Task> tasks;
  final Note? note;
  final Task task;
  final Function(String) onTextChanged;

  const TaskContainer({required this.task, required this.onTextChanged, required this.titleController, required this.descriptionController, required this.tasks, this.note});

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.task.text);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.task.isCompleted);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: widget.task.isCompleted,
            onChanged: (value) {
              setState(() {
                widget.task.isCompleted = value ?? false;
              });
            },
          ),
          const SizedBox(width: 8), // Add spacing between checkbox and TextField
          Expanded(
            child: TextField(
              onChanged: widget.onTextChanged,
              decoration: const InputDecoration(
                hintText: 'Enter task...',
                focusedBorder: InputBorder.none, // Remove underline
                enabledBorder: InputBorder.none, // Remove underline
              ),
              controller: _textEditingController,
              textAlign: TextAlign.left, // Make cursor move right
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
