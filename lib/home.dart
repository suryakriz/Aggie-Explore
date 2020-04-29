import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'CollectionOperations.dart';

int selected = 0;
var userId;

class Home extends StatefulWidget {
  Home(var id){
    userId = id;
  }
  @override
  HomePage createState() => HomePage();
}


class HomePage extends State<Home> {

  //GoogleMapController mapController;
  LatLng _coordinates;
  bool _gotCoords = false;

  List<Marker> markers = [];

  void initState() {

    super.initState();

    // Get list of markers from Firestore.
    Firestore.instance.collection("user_info").document(userId).get().then((snapshot) {
      var c_nos = snapshot.data["current challenges"];
      print("\n\n\n\n\nNumber of challenges: " + (c_nos.length).toString() + "\n\n\n\n\n");
      for (int i = 0; i < c_nos.length; i++) {
        print("\n\n\n\n\n\n\nIteration " + (i).toString() + "\n\n\n\n\n\n\n");
        Firestore.instance.collection("Markers").where("challenge number", isEqualTo: c_nos[i]).getDocuments().then((querySnapshot) {
          if (querySnapshot.documents.length != 0) {
            GeoPoint geo_pt = querySnapshot.documents[0].data["location"];
            markers.add(
                Marker (
                  markerId: MarkerId('Challenge ' + (i).toString()),
                  draggable: false,
                  position: LatLng(geo_pt.latitude, geo_pt.longitude),
                  infoWindow: InfoWindow (
                    title: 'Challenge ' + (i).toString(),
                  ),
                )
            );
            setState(() {});
          }
        });
      }
    });

    // Get user's current position.
    Geolocator().getCurrentPosition().then((c) {
      setState(() {
        _coordinates = LatLng(c.latitude, c.longitude);
        _gotCoords = true;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: StreamBuilder(
                  stream: Firestore.instance.collection("user_info").document(userId).snapshots(),
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
              markers: markers,
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
                      color: (selected == 0) ? Colors.orange[500] : Colors.orange[200],
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
    @required this.gotCoords,
    @required this.markers,
  });

  GoogleMapController mapController;
  final bool gotCoords;
  final LatLng coordinates;
  List<Marker> markers;


  Widget build(BuildContext context) {
    return (gotCoords)? GoogleMap(
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
      backgroundColor: Color(0xffd7f3f5),
      appBar: AppBar(
        title: Text("Friends"),
        backgroundColor: Color.fromRGBO(80, 0, 0, 1.0),
      ),
      body: Center(
        child: StreamBuilder (
            stream: Firestore.instance.collection("user_info").document(userId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Text("Go back!");
              }

              var friendsList = snapshot.data["friends"];

              List<Widget> friendsContainers = [];
              for (int i = 0; i < friendsList.length; i++) {
                friendsContainers.add(
                  Container (
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.all(16.0),
                    child: StreamBuilder (
                        stream: Firestore.instance.collection("user_info").document(friendsList[i]).snapshots(),
                        builder: (context2, snapshot2) {
                          if (!snapshot2.hasData) {
                            return new Text('Waiting for user friend data...');
                          }
                          return Column (
                            children: <Widget>[
                              RichText (
                                text: TextSpan (
                                  text: snapshot2.data["username"] + "    Lvl " + snapshot2.data["level"].toString(),
                                  style: TextStyle (
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(80, 0, 0, 1.0),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                    ),
                  ),
                );
              }

              return ListView(children: friendsContainers);
            }
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
                  MaterialPageRoute(builder: (context) => Home(userId)),
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
                  color: (selected == 0) ? Colors.orange[500] : Colors.orange[200],
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
      backgroundColor: Color(0xffd7f3f5),
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Color.fromRGBO(80, 0, 0, 1.0),
      ),
      body: Center(
          child: StreamBuilder (
              stream: Firestore.instance.collection("user_info").document(userId).snapshots(),
              builder: (context, snapshot) {

                var l = <Widget>[
                  Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.all(12.0),
                    child:
                    Text('Current Challenges:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //backgroundColor: Colors.yellow,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(80, 0, 0, 1.0),
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
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.all(12.0),
                        child: StreamBuilder(
                            stream: Firestore.instance.collection("Markers").where("challenge number", isEqualTo: challenges[i]).snapshots(),
                            builder: (_context, snapshot) {
                              if (!snapshot.hasData) {
                                return RichText(text: TextSpan(text: 'Waiting for data...'));
                              }
                              //return Text(snapshot.data.documents[0].data["name"]);
                              return Column (
                                children: <Widget>[
                                  RichText (
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Challenge " + challenges[i].toString() + ":\n",
                                        style: TextStyle(
                                          //backgroundColor: Colors.yellow,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(80, 0, 0, 1.0),
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: snapshot.data.documents[0].data["name"],

                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color.fromRGBO(80, 0, 0, 1.0),),
                                          )
                                        ]
                                    )
                                  ),
                                  RaisedButton (
                                    onPressed: () {
                                      
                                        Geolocator().getCurrentPosition().then((c) {
                                            
                                            GeoPoint challengeLoc = snapshot.data.documents[0].data["location"];
                                            isWithinRange (new LatLng(c.latitude, c.longitude), new LatLng(challengeLoc.latitude, challengeLoc.longitude)).then((bool inRange) {
                                              if (inRange) {
                                                completeChallenge (userId, challenges[i]);
                                                int points = snapshot.data.documents[0].data["points"];
                                                incrementUsrLevel(userId, points);
                                                showDialog (
                                                  context: _context,
                                                  builder: (BuildContext ctx) {
                                                    return AlertDialog (
                                                      title: new Text("Challenge " + i.toString() + " completed."),
                                                      content: new Text("You have advanced by " + points.toString() +" " + ((points == 1)? "point" : "points") + "."),
                                                      actions: <Widget>[
                                                        new FlatButton (
                                                          child: new Text ("OK"),
                                                          onPressed: () {
                                                              Navigator.of(ctx).pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  }
                                                );
                                              }
                                              else {
                                                showDialog (
                                                  context: _context,
                                                  builder: (BuildContext ctx) {
                                                    return AlertDialog (
                                                      title: new Text("Out of range."),
                                                      content: new Text("You are not within range of this area."),
                                                      actions: <Widget>[
                                                        new FlatButton (
                                                          child: new Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(ctx).pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  }
                                                );
                                              }
                                            });
                                            
                                        });
                                        return;
                                        //return 0;
                                      
                                    },
                                    child: Text (
                                      'Start',
                                      style: TextStyle (fontSize: 20)
                                    ),
                                  ),
                                ],
                              );
                            }
                        )
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
                  MaterialPageRoute(builder: (context) => Home(userId)),
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
                color: (selected == 0) ? Colors.orange[500] : Colors.orange[200],
                textColor: Colors.black,
                elevation: 10,
              ),
            ],
          )
      ),
    );
  }
}
