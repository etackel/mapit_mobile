import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/note.dart';
import '../../../shared/services/location_service.dart';
import '../../../shared/services/notification_service.dart';
import '../../providers/note_provider.dart';
import 'custom_widgets/navBar.dart';
import 'custom_widgets/note_card.dart';
import 'custom_widgets/fab.dart';
import 'custom_widgets/topBarWidget.dart';
import 'map_page.dart';


enum TabItem {
  notes,
  map,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationService locationService;
  late NotificationService notificationService;
  TabItem _currentTab = TabItem.notes;

  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  void initState() {
    super.initState();
    locationService = LocationService(context: context);
    notificationService = NotificationService();
    locationService.checkLocationPermission();
    locationService.configureNotificationOptions();
    locationService.startLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    List<Note> dummyNoteList = noteProvider.notes;

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        key: locationService.scaffoldKey,
        appBar: TopBar(scaffoldKey: locationService.scaffoldKey),
        body: _currentTab == TabItem.notes ? buildNotesList(dummyNoteList) : MapPage(),
        drawer: NavDrawer(),
        floatingActionButton: CustomFloatingActionButton(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  ListView buildNotesList(List<Note> dummyNoteList) {
    return ListView.builder(
      itemCount: dummyNoteList.length,
      itemBuilder: (context, index) {
        final Note note = dummyNoteList[index];
        return NoteTile(note: note);
      },
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTab.index,
      onTap: (index) => _selectTab(TabItem.values[index]),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
      ],
    );
  }
}