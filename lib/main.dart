import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';


import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:mapit/src/provider/note_provider.dart';
import 'package:mapit/src/provider/settings_provider.dart';
import 'package:mapit/src/provider/user_provider.dart';
import 'package:mapit/src/views/authentication/google_sign_in_view.dart';
import 'package:mapit/src/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsProvider = AppSettingsProvider();
  await settingsProvider.loadSettings();
  initPlatformState();
  await initializeService();
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

  await initializeService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      // notificationChannelId: 'mapit_channel',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: 10,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.reload();
  // final log = preferences.getStringList('log') ?? <String>[];
  // log.add(DateTime.now().toIso8601String());
  // await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final deviceInfo = DeviceInfoPlugin();
        String? device;
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model;
        }
        if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          device = iosInfo.model;
        }


        // geolocator.Position? position = await _getLiveCoordinates();
        // print(position!.longitude);
        // print(position!.longitude);

        // final coordinates = await _getLiveCoordinates();
        // service.setForegroundNotificationInfo(
        //   title: "MapIT is Running",
        //   content: "Device: $device\nLatitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}",
        // );

        service.setForegroundNotificationInfo(
          title: "MapIT is Running",
          content: "Ready to provide location-based notes",
        );


        // AwesomeNotifications().createNotification(
        //   content: NotificationContent(
        //     id: 10,
        //     channelKey: 'geofence_channel',
        //     title: 'Live Coordinates',
        //     body: 'Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}',
        //   ),
        // );
      }
    }

    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  });
}

void initPlatformState() async {
  print('Initializing...');
  print('Initialization done');
}

