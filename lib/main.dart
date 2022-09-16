import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  // final Location _location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  void _currentLocation() async {
    final GoogleMapController controller = mapController;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      // ignore: prefer_const_constructors
      final marker = Marker(
        markerId: const MarkerId('Silvia'),
        position: const LatLng(-7.843594, 112.514694),
        infoWindow: const InfoWindow(
          title: 'Silvia',
          snippet: 'Jl. Gunungsari',
        ),
      );

      setState(() {
        markers[const MarkerId('Silvia')] = marker;
      });
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        bearing: 0,
        target: LatLng(-7.843594, 112.514694),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Color.fromARGB(255, 122, 183, 243),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          myLocationEnabled: true,
          markers: markers.values.toSet(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _currentLocation,
          label: const Text('My Location'),
          backgroundColor: Color.fromARGB(255, 122, 183, 243),
          icon: const Icon(Icons.location_on),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}