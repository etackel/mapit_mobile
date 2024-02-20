import 'package:flutter/material.dart';
import 'package:mapit/src/views/create_note/create_note_view.dart';
import 'package:mapit/src/views/home/custom_widgets/fab.dart';
import 'package:mapit/src/views/home/custom_widgets/topBarWidget.dart';
import 'package:mapit/src/models/note.dart';
import 'package:provider/provider.dart';
import '../../provider/note_provider.dart';
import 'custom_widgets/note_card.dart';
import 'custom_widgets/sideDrawer.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    List<Note> dummyNoteList = noteProvider.notes;
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: TopBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<NoteProvider>(
                  builder: (context, noteProvider, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: dummyNoteList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                           InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateNoteScreen(
                                      note: dummyNoteList[index],
                                    ),
                                  ),
                                );
                              },
                              child: NoteTile(
                                note: dummyNoteList[index],
                              ),
                           ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        endDrawer: SideDrawer(),
        floatingActionButton: CustomFloatingActionButton(),
      ),
    );
  }
}
