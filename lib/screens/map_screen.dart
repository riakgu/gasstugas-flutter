import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  static const LatLng _telkomUniversity = LatLng(-6.973007,107.6291105);
  static const LatLng _gedungSate = LatLng(-6.9024715, 107.6161269);

  static const CameraPosition _initialPosition = CameraPosition(
    target: _telkomUniversity,
    zoom: 15,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('telkomUniversity'),
      position: _telkomUniversity,
      infoWindow: InfoWindow(title: 'Telkom University'),
    ),
  };

  void _moveToGedungSate() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _gedungSate,
          zoom: 15,
        ),
      ),
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('gedungSate'),
          position: _gedungSate,
          infoWindow: InfoWindow(title: 'Gedung Sate'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToGedungSate,
        child: Icon(Icons.location_on),
        tooltip: 'Move to Gedung Sate',
      ),
    );
  }
}
