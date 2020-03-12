import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
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
          ),
        ):
        Center(
          child: 
            Text('Waiting for location services.'),
        ),
      ),
    );
  }
}