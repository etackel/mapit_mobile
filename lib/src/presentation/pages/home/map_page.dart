// map_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/note.dart';
import '../../providers/note_provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Location location = Location();
  LocationData? currentLocation;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _retrieveLocation();
  }

  Future<void> _retrieveLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _errorMessage = 'Location services are disabled.';
            _isLoading = false;
          });
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _errorMessage = 'Location permissions are denied.';
            _isLoading = false;
          });
          return;
        }
      }

      currentLocation = await location.getLocation();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error retrieving location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    List<Note> notes = noteProvider.notes;

    // Create markers for each note
    _markers = notes.map((note) {
      return Marker(
        markerId: MarkerId(note.noteId),
        position: LatLng(note.latitude, note.longitude),
        infoWindow: InfoWindow(title: note.title),
      );
    }).toSet();

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // Use a default location if current location is not available
    final defaultLocation = LatLng(0, 0);
    final mapLocation = currentLocation != null
        ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
        : defaultLocation;

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      initialCameraPosition: CameraPosition(
        target: mapLocation,
        zoom: 14.0,
      ),
      markers: _markers,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}