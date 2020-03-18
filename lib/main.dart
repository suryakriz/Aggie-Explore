import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}


class HomePage extends State<MyApp> {
  GoogleMapController mapController;
  LatLng coordinates;
  bool gotCoords = false;

  // Temporary in-progress example marker implementation.
  List<Marker> markers = [
    Marker(
      markerId: MarkerId('Challenge 1'),
      draggable: false,
      position: LatLng(37.4244, -122.0824),
      infoWindow: InfoWindow(
        title: 'Challenge 1',
      ),
    )
  ];

  void initState() {

    super.initState();
    
    Geolocator().getCurrentPosition().then((c) {
      setState(() {
        coordinates = LatLng(c.latitude, c.longitude);
        gotCoords = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('<User Information to be added>'),
        ),
        body: gotCoords ? GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: coordinates,
            zoom: 15.0,
          ), // CameraPosition
          markers: Set.from(markers),
        ):
        Center(
          child: 
            Text('Waiting for location services.'),
        ),
      ),
    );
  }
}