import 'package:flutter/material.dart';
import 'package:mapit/src/models/task.dart';

class TaskContainer extends StatefulWidget {
  final Task task;
  final Function(String) onTextChanged;

  const TaskContainer({required this.task, required this.onTextChanged});

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
