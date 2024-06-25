import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapit/src/provider/note_provider.dart';
import 'package:mapit/src/provider/settings_provider.dart';
import 'package:mapit/src/provider/user_provider.dart';
import 'package:mapit/src/views/authentication/google_sign_in_view.dart';
import 'package:mapit/src/views/create_note/create_note_view.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await dotenv.DotEnv().load();
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundIsolateBinaryMessenger.ensureInitialized;
  final settingsProvider = AppSettingsProvider();
  await settingsProvider.loadSettings();
  createShortcut();
  handleShortcut();
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
    debug: false,
  );
  bool isAllowedNotification = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  // AwesomeNotifications().createNotification(content: NotificationContent(
  //   id: 10,
  //   channelKey: 'geofence_channel',
  //   title: 'Welcome to Mapit',
  //   body: 'Get started with your location-based notes',
  // ));


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    ),
  );
}

void createShortcut() {
  final QuickActions quickActions = QuickActions();
  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
      type: 'action_create_note', // Unique ID for the shortcut
      localizedTitle: 'Create Note',
      icon: 'create_note', // The name of the icon file
    ),
  ]);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleShortcut() {
  final QuickActions quickActions = QuickActions();
  quickActions.initialize((String shortcutType) {
    if (shortcutType == 'action_create_note') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => CreateNoteScreen()),
      );
    }
  });
}
