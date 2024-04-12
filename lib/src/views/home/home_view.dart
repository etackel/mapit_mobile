import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../../provider/note_provider.dart';
import 'custom_widgets/navBar.dart';
import 'custom_widgets/note_card.dart';
import 'custom_widgets/fab.dart';
import 'custom_widgets/topBarWidget.dart';
import '../../models/note.dart';
import '../create_note/create_note_view.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Initialize necessary services
    WidgetsFlutterBinding.ensureInitialized();

    // Example background task logic
    if (task == "locationUpdates") {
      // Retrieve data needed for location updates (e.g., notes)
      List<Note> notes = _retrieveNotes();
      _updateLocationInBackground(notes);
    } else {
      print("Unknown task: $task");
    }

    return Future.value(true); // Return a Future
  });
}

// Function to retrieve notes
List<Note> _retrieveNotes() {
  // Create an instance of NoteProvider
  NoteProvider noteProvider = NoteProvider();

  // Access the list of notes from the provider
  List<Note> notes = noteProvider.notes;

  return notes;
}

void _updateLocationInBackground(List<Note> notes) {
  // Perform location updates or any other background task
  Location().getLocation().then((LocationData locationData) {
    // Process location data
    print("Location updated in background: $locationData");
    // Check geofences based on the updated location
    _checkGeofenceInBackground(locationData, notes);
    print(notes.first.noteId.toString());
  }).catchError((error) {
    print("Error updating location in background: $error");
  });
}

void _checkGeofenceInBackground(LocationData locationData, List<Note> notes) {
  // Check geofences against the updated location
  for (Note note in notes) {
    int noteLatitudeInt = note.latitude?.toInt() ?? 0;
    int noteLongitudeInt = note.longitude?.toInt() ?? 0;

    int userLatitudeInt = locationData.latitude?.toInt() ?? 0;
    int userLongitudeInt = locationData.longitude?.toInt() ?? 0;

    if (userLatitudeInt == noteLatitudeInt && userLongitudeInt == noteLongitudeInt) {
      _showNoteFoundNotification();
      print("Note found near your location: ${note.title}");
      break;
    }
  }
}

void _showNoteFoundNotification() async {
  AwesomeNotifications awesomeNotifications = new AwesomeNotifications();
  awesomeNotifications.createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'geofence_channel',
      title: 'Note Found',
      body: 'You are near a note!',
      notificationLayout: NotificationLayout.BigText,
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the background task
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    '1', // Unique ID for the task
    'locationUpdates', // Task name
    frequency: Duration(seconds: 3), // Adjust as needed
  );  AwesomeNotifications().initialize(
    // Add your initialization settings here
    null,
    [
      NotificationChannel(
        channelKey: 'geofence_channel',
        channelName: 'Geofence Channel',
        channelDescription: 'Channel for geofence notifications',
        defaultColor: Colors.green,
        ledColor: Colors.green,
        playSound: true,
        enableVibration: true,
      ),
    ],
  );

  runApp(HomeScreen());
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Location location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;


  @override
  void initState() {
    super.initState();
    location = Location();
    _checkLocationPermission();
    _configureNotificationOptions();
    _startLocationUpdates();
  }

  Future<void> _checkLocationPermission() async {

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  void _configureNotificationOptions() {
    location.changeNotificationOptions(
      title: 'Geolocation',
      subtitle: 'Geolocation detection',
    );
  }


  void _startLocationUpdates() {
    // Run location updates task periodically in the background
    Workmanager().registerPeriodicTask(
      'locationUpdates',
      'locationUpdatesTask',
      frequency: Duration(minutes: 15), // Adjust as needed
    );

    // Listen for location changes in the foreground
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
        NoteProvider noteProvider = Provider.of<NoteProvider>(context, listen: false);
        List<Note> notes = noteProvider.notes;
        checkGeofence(notes);
        print("Location updated: $_locationData");
      });
    });
  }

  void checkGeofence(List<Note> notes) {
    for (Note note in notes) {
      int noteLatitudeInt = note.latitude?.toInt() ?? 0;
      int noteLongitudeInt = note.longitude?.toInt() ?? 0;

      int userLatitudeInt = _locationData.latitude?.toInt() ?? 0;
      int userLongitudeInt = _locationData.longitude?.toInt() ?? 0;

      if (userLatitudeInt == noteLatitudeInt && userLongitudeInt == noteLongitudeInt) {
        _showNoteFoundNotification();
        print("Note found near your location: ${note.title}");
        break;
      }
    }
  }


  void _showNoteFoundNotification() async {
    AwesomeNotifications awesomeNotifications = new AwesomeNotifications();
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'geofence_channel',
        title: 'Note Found',
        body: 'You are near a note!',
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    List<Note> dummyNoteList = noteProvider.notes;

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        key: _scaffoldKey, // Set the key here
        appBar: TopBar(scaffoldKey: _scaffoldKey), // Pass the key to the TopBar
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

        drawer: NavDrawer(), // Drawer on the left side
        floatingActionButton: CustomFloatingActionButton(),
      ),
    );
  }
}
