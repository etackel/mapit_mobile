import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' ;
import 'package:mapit/src/models/note.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/save_note_options.dart';
import '../add_location/add_location_view.dart';
import 'custom_widgets/location_dialog.dart';
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
  String currentAddress = 'Trying to get your current location...';
  LocationData currentLocationData = LocationData.fromMap({});
  bool isLoading = true; // Add isLoading state

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title);
    descriptionController =
        TextEditingController(text: widget.note?.description);
    tasks = widget.note?.taskList
        ?.map((task) => Task(text: task.text, isCompleted: task.isCompleted))
        .toList() ??
        [Task(text: '', isCompleted: false)];
    if(widget.note?.address == null) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationData? locationData;
    final location = Location();
    try {
      locationData = await location.getLocation();
      currentLocationData = locationData;
      final placemarks = await geocoding.placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      String output = 'No results found.';
      if (placemarks.isNotEmpty) {
        output = placemarks[0].toString();
        setState(() {
          currentAddress = ' ${placemarks[0].street},  ${placemarks[0].subLocality} ' ?? '';
          isLoading = false; // Set isLoading to false when location data is fetched
        });
      }
    } catch (error) {
      print("Error getting location: $error");
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
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
          appBar: TopBar(
              titleController, descriptionController, tasks, widget.note, currentAddress, currentLocationData),
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
                                      (_) => _addNewTask(),
                                );
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
                    // _saveNote();
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => LocationBottomSheet(
                        address: currentAddress,
                        note: widget.note != null ? widget.note! : null,
                      ), // Use the LocationBottomSheet widget
                    );
                  },
                  child: LocationButton(
                    address: widget.note != null ? widget.note!.address : '',
                    note: widget.note != null ? widget.note! : null,
                  ),
                ),
              ),
              // Add CircularProgressIndicator based on isLoading
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
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
    NoteUtils.saveNote(context, titleController, descriptionController, tasks, widget.note, currentAddress, currentLocationData);
  }

  void _shareNote() {
    final noteContent = _buildNoteContent(titleController.text, descriptionController.text, tasks);
    Share.share(noteContent);
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
