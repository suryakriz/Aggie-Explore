import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

int selected = 0;
var userId = "L91n5oq9UtI10FWEUg81";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}


class HomePage extends State<MyApp> {
  
  //GoogleMapController mapController;
  LatLng _coordinates;
  bool _gotCoords = false;

  /*
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
  
  */
  /*
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {

  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("user_info").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("...");
        }
        else {
          return _buildList(context, snapshot.data.documents);
        }
      }
    )
  }
  */
  var usrId = "L91n5oq9UtI10FWEUg81";
  /*
  Text getUsrInfo() {
    Firestore.instance.collection("user_info").document(usrId).get().then((DocumentSnapshot snapshot) {
          return snapshot.data["username"].toString();
    });
    var document = await Firestore.instance.collection("user_info").document(usrId);
    document.get() => then((document) {
        return document("username");
    });
  }
  */

  void initState() {

    super.initState();

    
    
    Geolocator().getCurrentPosition().then((c) {
      setState(() {
        _coordinates = LatLng(c.latitude, c.longitude);
        _gotCoords = true;
      });
    });
  }

  //var usrname = "<Waiting for user information.>";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
        appBar: AppBar(
            title: StreamBuilder(
                stream: Firestore.instance.collection("user_info").document(usrId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("<Waiting for user information.");
                  }
                  var usrDoc = snapshot.data;
                  return new Text(usrDoc["username"] + "     Lvl " + usrDoc["level"].toString());
                }
            )
        ),
        body: (selected == 0)? Map(
          gotCoords: _gotCoords,
          coordinates: _coordinates,
        ):
        Center(
          child: Text("Frends/Profile page"),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white.withOpacity(0.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {setState(() => selected = 0);},
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Home", style: TextStyle(fontSize: 30)),
                color: (selected == 0) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
              RaisedButton(
                onPressed: () => {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsPage()),
                )
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Friends", style: TextStyle(fontSize: 30)),
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10
              ),
              RaisedButton(
                onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Profile", style: TextStyle(fontSize: 30)),
                color: (selected == 2) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
            ],
          )
        ),
      ),
    )
    );
  }
}

class Map extends StatelessWidget {

  Map({
    @required this.coordinates,
    @required this.gotCoords
  });

  GoogleMapController mapController;
  final bool gotCoords;
  final LatLng coordinates;

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
  Widget build(BuildContext context) {
    return gotCoords? GoogleMap(
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
      child: Text("Waiting for location services."),
    );
  }
}

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FriendsPage"),
      ),
      body: Center(
          child: Text('Go back!'),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white.withOpacity(0.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Home", style: TextStyle(fontSize: 30)),
                color: (selected == 0) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
              RaisedButton(
                onPressed: () => {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsPage()),
                )
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Friends", style: TextStyle(fontSize: 30)),
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10
              ),
              RaisedButton(
                onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Profile", style: TextStyle(fontSize: 30)),
                color: (selected == 2) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
            ],
          )
        ),
      );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Center(
          child: Text('Go back!'),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white.withOpacity(0.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Home", style: TextStyle(fontSize: 30)),
                color: (selected == 0) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
              RaisedButton(
                onPressed: () => {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsPage()),
                )
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Friends", style: TextStyle(fontSize: 30)),
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10
              ),
              RaisedButton(
                onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(13.5),
                ),
                child: const Text("Profile", style: TextStyle(fontSize: 30)),
                color: (selected == 2) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
            ],
          )
        ),
      );
  }
}