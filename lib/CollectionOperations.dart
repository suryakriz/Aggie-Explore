
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void incrementUsrLevel(String user_id, int increase) async {
    DocumentReference userRef = await Firestore.instance.collection("user_info").document(user_id);
    await userRef.updateData({"level": FieldValue.increment(increase)});
}

Future<void> completeChallenge(String user_id, int c_no) async {
  await _removeFromCurrentChallenges(user_id, c_no);
  await _addToCompletedChallenges(user_id, c_no);
}

    Future<void> _removeFromCurrentChallenges(String user_id, int c_no) {
      var list = List<int>();
      list.add(c_no);
      Firestore.instance.collection("user_info").document(user_id).updateData({"current challenges": FieldValue.arrayRemove(list)});
    }

    Future<void> _addToCompletedChallenges(String user_id, int c_no) {
      var list = List<int>();
      list.add(c_no);
      Firestore.instance.collection("user_info").document(user_id).updateData({"completed challenges": FieldValue.arrayUnion(list)});
    }

Future<bool> isWithinRange(LatLng position, LatLng target) async {
    /*
    const double RANGE_CONST = 0.001;
    if ( (position.latitude - target.latitude).abs() < RANGE_CONST && (position.longitude - target.longitude).abs() < RANGE_CONST ) {
      return true;
    }
    return false;
    */

  const int RANGE_CONST_METERS = 100; // If user is within this many meters of the center coordinates, they are considered to be at that location.

  double dist = await Geolocator().distanceBetween(position.latitude, position.longitude, target.latitude, target.longitude);
  print("\n\n\n\n\nDIST=" + dist.toString() + "\n\n\n\n\n");
  if (dist < RANGE_CONST_METERS) {
    return true;
  }
  return false;
}


