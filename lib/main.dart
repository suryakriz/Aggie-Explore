import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'CollectionOperations.dart';

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


  var usrId = "L91n5oq9UtI10FWEUg81";

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
                ),
                backgroundColor: Color.fromRGBO(80, 0, 0, 1.0),
            ),
            body: (selected == 0)? Map(
              gotCoords: _gotCoords,
              coordinates: _coordinates,
            ):
            Center(
              child: Text("Frends/Profile page"),
            ),
            bottomNavigationBar: BottomAppBar(
                color: Color.fromRGBO(80, 0, 0, 1.0),
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
                      color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
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
        title: Text("Friends Page"),
        backgroundColor: Color.fromRGBO(80, 0, 0, 1.0),
      ),
      body: Center(
        child:
        Column(
          children: [
            Text('Go back!'),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(80, 0, 0, 1.0),
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
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
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
                  color: (selected == 0) ? Colors.orange[300] : Colors.orange[200],
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
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
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
        backgroundColor: Color.fromRGBO(80, 0, 0, 1.0),
      ),
      body: Center(
          child: StreamBuilder (
              stream: Firestore.instance.collection("user_info").document("L91n5oq9UtI10FWEUg81").snapshots(),
              builder: (context, snapshot) {
                var l = <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.all(16.0),
                    child:
                    Text('Current Challenges',
                      style: TextStyle(
                        backgroundColor: Colors.yellow,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  )
                ];
                if (!snapshot.hasData) {
                  return ListView(children: l);
                }
                var usrDoc = snapshot.data;
                List<int> challenges = List.from(usrDoc["current challenges"]);
                for (var i = 0; i < challenges.length; i++) {
                  l.add(
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.all(16.0),
                      child:
                      Text('Challenge ' + challenges[i].toString(),
                        style: TextStyle(
                          backgroundColor: Colors.yellow,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return ListView(children: l);
              }
          )
      ),
      /*
        body: Center(
          child:
            Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                child:
                  Text('Current Challenges',
                    style: TextStyle(
                    backgroundColor: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                child:
                  Text('Challenge 1',
                    style: TextStyle(
                    backgroundColor: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                child:
                  Text('Challenge 2',
                    style: TextStyle(
                    backgroundColor: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                child:
                  Text('Challenge 3',
                    style: TextStyle(
                    backgroundColor: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
          ),
        */
      bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(80, 0, 0, 1.0),
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
                color: (selected == 1) ? Colors.orange[300] : Colors.orange[200],
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
                color: (selected == 0) ? Colors.orange[300] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
            ],
          )
      ),
    );
  }
}
