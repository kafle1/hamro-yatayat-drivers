import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  Future driverExists({required String driverId}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();

      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e;
    }
  }

  Future sendMessage(
      {required String driverId,
      required String subject,
      required String messsage}) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .add({'driverId': driverId, 'subject': subject, 'message': messsage});

      return 'Added New Feedback Successfully';
    } catch (e) {
      return e;
    }
  }
}
