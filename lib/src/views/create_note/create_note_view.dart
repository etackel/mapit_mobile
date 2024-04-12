import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapit/src/views/create_note/custom_widgets/location_dialog.dart';
import 'package:provider/provider.dart';
import 'package:mapit/src/models/note.dart';
import 'package:mapit/src/provider/note_provider.dart';
import '../../utils/save_note.dart';
import '../add_location/add_location_view.dart';
import 'custom_widgets/task_container.dart';
import 'custom_widgets/topBar.dart';
import 'custom_widgets/add_location_button.dart';
import '../../models/task.dart';

class CreateNoteScreen extends StatefulWidget {
  final Note? note;

  CreateNoteScreen({this.note});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title);
    descriptionController =
        TextEditingController(text: widget.note?.description);
    tasks =
        widget.note?.taskList?.map((task) => Task(text: task.text, isCompleted: task.isCompleted)).toList() ??
            [Task(text: '', isCompleted: false)];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPop');
        _saveNote();
        return true;
      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: TopBar(titleController, descriptionController, tasks, widget.note),
          body: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          onChanged: (text) {},
                          onEditingComplete: _saveNote,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              color: Color(0xFF156FEE),
                              fontSize: 20,
                              fontFamily: 'Gilroy-SemiBold',
                              fontWeight: FontWeight.w400,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF156FEE)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF156FEE)),
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF156FEE),
                            fontSize: 20,
                            fontFamily: 'Gilroy-SemiBold',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: descriptionController,
                          onChanged: (text) {},
                          onEditingComplete: _saveNote,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 14,
                              fontFamily: 'Gilroy-Regular',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 14,
                            fontFamily: 'Gilroy-Regular',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskContainer(
                          task: tasks[index],
                          onTextChanged: (text) {
                            setState(() {
                              tasks[index] = Task(text: text, isCompleted: false);
                              // Auto-add an empty task when the user enters something
                              if (text.isNotEmpty &&
                                  index == tasks.length - 1) {
                                WidgetsBinding.instance!.addPostFrameCallback(
                                        (_) => _addNewTask());
                              }
                            });
                          },
                          titleController: titleController,
                          descriptionController: descriptionController,
                          tasks: tasks,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    _saveNote();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return widget.note == null
                            ? MapScreen()
                            : LocationDialog(
                          address: widget.note?.address,
                        );
                      }),
                    );
                  },
                  child: LocationButton(
                    address: widget.note?.address,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewTask() {
    NoteUtils.addNewTask(tasks, setState);
  }

  void _saveNote() {
    NoteUtils.saveNote(context, titleController, descriptionController, tasks, widget.note);
  }
}
