
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void incrementUsrLevel(String user_id, int increase) async {
    DocumentReference userRef = await Firestore.instance.collection("user_info").document(user_id);
    await userRef.updateData({"level": FieldValue.increment(increase)});
}

void completeChallenge(String user_id, int c_no) async {
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


