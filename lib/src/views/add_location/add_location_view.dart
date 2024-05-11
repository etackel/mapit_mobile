import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
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
    LocationData? locationData;
    final location = Location();
    try {
      locationData = await location.getLocation();
      setState(() {
        _initialCameraPosition =
            LatLng(locationData!.latitude!, locationData.longitude!);
        _isLoading = false;
      });
    } catch (error) {
      print("Error getting location: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialCameraPosition,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      setState(() {
                        _controller = controller;
                      });
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
              );
  }
}

