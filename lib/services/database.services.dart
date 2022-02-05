import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Database {
  //Check if the driver exists in the datbase
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

  //Send feedback message to the driver

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

  Future createBidding(
      {required int price,
      required String remarks,
      required String bookingId}) async {
    try {
      await FirebaseFirestore.instance.collection('biddings').add({
        'driverId': GetStorage().read('driverId'),
        'bookingId': bookingId,
        'amount': (2.5 / 100) * price + price,
        'remarks': remarks,
        'bookingStatus': 'Pending'
      });
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(GetStorage().read('driverId'))
          .set({
        'myBiddings': FieldValue.arrayUnion([bookingId])
      }, SetOptions(merge: true));
      return 'Success';
    } catch (e) {
      return e;
    }
  }
}
