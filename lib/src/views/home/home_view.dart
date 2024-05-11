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
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(callbackDispatcher);
    if (task == "locationUpdates") {
      List<Note> notes = _retrieveNotes();
      _updateLocationInBackground(notes);
    } else {
      print("Unknown task: $task");
    }
    return Future.value(true);
  });
}

List<Note> _retrieveNotes() {
  NoteProvider noteProvider = NoteProvider();
  List<Note> notes = noteProvider.notes;
  return notes;
}

void _updateLocationInBackground(List<Note> notes) {
  Location().getLocation().then((LocationData locationData) {
    print("Location updated in background: $locationData");
    _checkGeofenceInBackground(locationData, notes);
  }).catchError((error) {
    print("Error updating location in background: $error");
  });
}

void _checkGeofenceInBackground(LocationData locationData, List<Note> notes) {
  print("Checking geofence in background");
  for (Note note in notes) {
    int noteLatitudeInt = note.latitude?.toInt() ?? 0;
    int noteLongitudeInt = note.longitude?.toInt() ?? 0;

    int userLatitudeInt = locationData.latitude?.toInt() ?? 0;
    int userLongitudeInt = locationData.longitude?.toInt() ?? 0;

    if (userLatitudeInt == noteLatitudeInt &&
        userLongitudeInt == noteLongitudeInt) {
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
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    '1',
    'locationUpdates',
    frequency: Duration(seconds: 3),
  );
  AwesomeNotifications().initialize(
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
    Workmanager().registerPeriodicTask(
      'locationUpdates',
      'locationUpdatesTask',
      frequency: Duration(minutes: 15),
    );

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
        NoteProvider noteProvider =
            Provider.of<NoteProvider>(context, listen: false);
        List<Note> notes = noteProvider.notes;
        checkGeofence(notes);
        print("Location updated: $_locationData");
      });
    });
  }

  void checkGeofence(List<Note> notes) {
    const double radius = 1; // Radius in kilometers

    for (Note note in notes) {
      double noteLatitude = note.latitude ?? 0;
      double noteLongitude = note.longitude ?? 0;

      double userLatitude = _locationData.latitude ?? 0;
      double userLongitude = _locationData.longitude ?? 0;

      double distance = calculateDistance(noteLatitude, noteLongitude, userLatitude, userLongitude);

      if (distance <= radius) {
        _showNoteFoundNotification();
        print("Note found near your location: ${note.title}");
        break;
      }
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int R = 6371; // Radius of the Earth in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    double a = sin(dLat/2) * sin(dLat/2) +
        sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));

    return R * c; // Distance in kilometers
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
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
        key: _scaffoldKey,
        appBar: TopBar(scaffoldKey: _scaffoldKey),
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
                        final Note note = dummyNoteList[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.horizontal,
                              background: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), // Rounded rectangles
                                  color: Colors.green.withOpacity(0.8), // Color for pinning with opacity
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(Icons.push_pin, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Pin', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), // Rounded rectangles
                                  color: Colors.red.withOpacity(0.8), // Color for deleting with opacity
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Delete', style: TextStyle(color: Colors.white)),
                                    SizedBox(width: 10),
                                    Icon(Icons.delete, color: Colors.white),
                                  ],
                                ),
                              ),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  // Delete note if swiped from right to left
                                  noteProvider.deleteNote(index);
                                } else if (direction == DismissDirection.startToEnd) {
                                  // Toggle pin status if swiped from left to right
                                  note.isPinned = !note.isPinned;
                                  noteProvider.updateNote(noteProvider.notes.indexWhere((n) => n.noteId == note.noteId), note);
                                }
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateNoteScreen(
                                        note: note,
                                      ),
                                    ),
                                  );
                                },
                                child: NoteTile(
                                  note: note,
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
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

        drawer: NavDrawer(),
        floatingActionButton: CustomFloatingActionButton(),
      ),
    );
  }


}
