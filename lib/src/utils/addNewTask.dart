import 'package:flutter/material.dart';

import '../models/task.dart';

void addNewTask(List<Task> tasks, Function setState) {
  tasks.add(Task(text: '', isCompleted: false));
  setState(() {});
}
