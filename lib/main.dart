import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mapit/src/provider/note_provider.dart';
import 'package:mapit/src/provider/user_provider.dart';
import 'package:mapit/src/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await AwesomeNotifications().initialize(
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
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'geofence_channel_group',
        channelGroupName: 'Geofence Channel Group',
      ),
    ],
  );
  bool isAllowedNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedNotification){
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  AwesomeNotifications().createNotification(content: NotificationContent(
    id: 10,
    channelKey: 'geofence_channel',
    title: 'Welcome to Mapit',
    body: 'Get started with your location-based notes',
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(

        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
        ),

    );
  }
}
