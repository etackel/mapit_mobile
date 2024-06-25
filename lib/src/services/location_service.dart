import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/priority.dart';
import '../models/note.dart';
import '../provider/note_provider.dart';
import '../provider/settings_provider.dart';
import 'notification_service.dart';


class LocationService {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late Location location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  LocationService({required this.context}) {
    location = Location();
  }

  Future<void> checkLocationPermission() async {
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

  void configureNotificationOptions() {
    location.changeNotificationOptions(
      title: 'Geolocation',
      subtitle: 'Geolocation detection',
    );
  }

  void startLocationUpdates() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
      NoteProvider noteProvider =
      Provider.of<NoteProvider>(context, listen: false);
      List<Note> notes = noteProvider.notes;
      checkGeofence(notes);
      print("Location updated: $_locationData");
    });
  }

  void checkGeofence(List<Note> notes) {
    final settingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);

    for (Note note in notes) {
      if(note.isSilent){
        return;
      }
      else {
        double radius;
        switch (note.label) {
          case 'low':
            radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.low).distance/1000;
            break;
          case 'moderate':
            radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.moderate).distance/1000;
            break;
          case 'high':
            radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.high).distance/1000;
            break;
          default:
            radius = 0;
        }

        double noteLatitude = note.latitude;
        double noteLongitude = note.longitude;
        double userLatitude = _locationData.latitude ?? 0;
        double userLongitude = _locationData.longitude ?? 0;

        double distance = calculateDistance(noteLatitude, noteLongitude, userLatitude, userLongitude);

        if (distance <= radius ) {
          NotificationService().showNoteFoundNotification(note);
          print("Note found near your location: ${note.title}");
          break;
        }
      }
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int R = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    double a = sin(dLat/2) * sin(dLat/2) +
        sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));

    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }


}