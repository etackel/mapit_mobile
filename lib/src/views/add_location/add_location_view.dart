import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:mapit/src/utils/save_note_options.dart';
import 'dart:convert';
import 'package:mapit/src/models/note.dart';
import 'package:provider/provider.dart';
import '../../provider/note_provider.dart';

Set<Marker> _markers = {};
Set<Circle> _circles = {};

class MapScreen extends StatefulWidget {
  final String NoteId;
  final Function(LatLng) onLocationSelected;

  MapScreen({required this.onLocationSelected, required this.NoteId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late LatLng _initialCameraPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (error) {
      print("Error getting location: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _getSuggestions(String query) async {
    DotEnv env = DotEnv();
    print('Getting suggestions for: $query'); // Debug log
    String? apiKey = env.env['GOOGLE_MAPS_API_KEY'];
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['predictions'];
      print('Received suggestions: $data'); // Debug log
      return data.map((item) => item['description']).toList().cast<String>();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: true);
    late Note localNote =
        noteProvider.notes.firstWhere((note) => note.noteId == widget.NoteId);
    print('Adress of local note' + localNote.address); // Debug log
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LocationSearch(_getSuggestions, _controller),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: localNote.address == 'No Location Selected'
                    ? _initialCameraPosition
                    : LatLng(localNote.latitude, localNote.longitude),
                zoom: 14,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              circles: _circles,
              onTap: (LatLng location) {
                setState(() {
                  print(
                      'Location selected: ${location.longitude}');
                  _markers.clear();
                  _markers.add(
                    Marker(
                      markerId: MarkerId(location.toString()),
                      position: location,
                    ),
                  );
                  final noteProvider = Provider.of<NoteProvider>(context, listen: false);
                  // Note note = noteProvider.notes.firstWhere((note) => note.noteId == widget.NoteId);
                  //
                  // final settingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
                  // double radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == note.label).distance;
                  // _circles.clear();
                  // _circles.add(
                  //   Circle(
                  //     circleId: CircleId(location.toString()),
                  //     center: location,
                  //     radius: radius,
                  //     fillColor: Colors.blue.withOpacity(0.3),
                  //     strokeColor: Colors.blue,
                  //     strokeWidth: 1,
                  //   ),
                  // );
                });
                // Save the location
                _saveLocation(location);

              },
            ),
    );
  }

  Future<void> _saveLocation(LatLng location) async {
    String address = await _getAddress(location);
    print('Saving location: $location, $address'); // Debug log
    NoteUtils.updateNoteLocation(context, widget.NoteId, address, location);

    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId(location.toString()),
        position:
        LatLng(location.latitude, location.longitude),
      ),
    );

  }

  Future<String> _getAddress(LatLng location) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    return placemarks[0].street.toString();
  }
}

class LocationSearch extends SearchDelegate<String> {
  final Future<List<String>> Function(String) getSuggestions;
  final GoogleMapController _controller;

  LocationSearch(this.getSuggestions, this._controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder<List<String>>(
      future: getSuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error getting suggestions: ${snapshot.error}'); // Debug log
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final suggestions = snapshot.data ?? [];
        print('Displaying suggestions: $suggestions'); // Debug log

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                // Convert the location name to coordinates
                List<Location> locations =
                    await locationFromAddress(suggestions[index]);
                print('MOVING TO SEARCHED LOCATION');
                // Show a progress indicator while the map is moving
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: new CircularProgressIndicator(),
                    );
                  },
                );
                await _controller.moveCamera(
                  CameraUpdate.newLatLng(
                    LatLng(locations[0].latitude, locations[0].longitude),
                  ),
                );
                // Add a marker at the searched location
                _markers.clear();
                _markers.add(
                  Marker(
                    markerId: MarkerId(locations[0].toString()),
                    position:
                        LatLng(locations[0].latitude, locations[0].longitude),
                  ),
                );

                // Close the progress indicator
                Navigator.pop(context);
                // Close the search delegate
                close(context, suggestions[index]);
              },
              title: Text(suggestions[index]),
            );
          },
        );
      },
    );
  }
}
