// map_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../provider/note_provider.dart';
import '../../models/note.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  Location location = Location();
  late LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  Future<void> retrieveLocation() async {
    currentLocation = await location.getLocation();
    setState(() {});
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

    return currentLocation == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 14.0,
      ),
      markers: _markers,
    );
  }
}