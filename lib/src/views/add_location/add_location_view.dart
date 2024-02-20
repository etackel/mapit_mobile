import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const String kGoogleMapsApiKey = 'AIzaSyCQdbg4xwYyU878Dwd55qAi_XDw4_fec58'; // Replace with your API key

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = LatLng(10.0, 50.0); // Initial center
  TaskPriority _priority = TaskPriority.Normal;
  TextEditingController _searchController = TextEditingController();
  List<Marker> _markers = [];
  final places = GoogleMapsPlaces(apiKey: kGoogleMapsApiKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Task'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 16.0,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: Set<Marker>.from(_markers),
            onCameraMove: (CameraPosition position) {
              _updateLocation(position.target);
            },
          ),

          Positioned(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1.0,
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) async {
                  if (value.isEmpty) {
                    _clearMarkers();
                    return; // Handle empty search
                  }

                  // Perform Places API autocomplete for search predictions
                  PlacesAutocompleteResponse response = await places.autocomplete(
                    value,
                    location: Location(lat: _selectedLocation.latitude, lng: _selectedLocation.longitude),
                    radius: 1000,
                  );

                  _updateMarkers(response.predictions);
                },
              ),
            ),
          ),

          Positioned(
            bottom: 20.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () => _saveTask(),
              child: Icon(Icons.save),
            ),
          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 180.0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Priority:'),
                  DropdownButton<TaskPriority>(
                    value: _priority,
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem<TaskPriority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (priority) => setState(() => _priority = priority!),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateLocation(LatLng location) {
    _selectedLocation = location;
    _clearMarkers();
    setState(() {});
  }

  void _updateMarkers(List<Prediction> predictions) {
    _clearMarkers();

    predictions.forEach((prediction) async {
      PlacesDetailsResponse details = await places.getDetailsByPlaceId(prediction.placeId!);

      final Marker marker = Marker(
        markerId: MarkerId(details.result.placeId),
        position: LatLng(
          details.result.geometry!.location.lat,
          details.result.geometry!.location.lng,
        ),
        infoWindow: InfoWindow(
          title: details.result.name,
          snippet: details.result.formattedAddress!,
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  void _clearMarkers() {
    setState(() {
      _markers.clear();
    });
  }

  void _saveTask() {
    // Implement the logic to save the task with the selected location and priority
  }
}

// Task priority enum
enum TaskPriority { Low, Normal, High }
