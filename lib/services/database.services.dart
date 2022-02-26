import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';

class Database {
  final Stream<QuerySnapshot> _imagesStream = FirebaseFirestore.instance
      .collection('images')
      .where('isDriverPoster', isEqualTo: true)
      .snapshots();

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

  StreamBuilder<QuerySnapshot<Object?>> createCrousel() {
    return StreamBuilder<QuerySnapshot>(
      stream: _imagesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }

        return Carousel(
          images: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Image.network(
              data['url'],
              fit: BoxFit.fill,
            );
          }).toList(),
          dotSize: 5,
          dotSpacing: 15,
          indicatorBgPadding: 5,
          dotColor: Colors.white60,
          dotBgColor: Colors.transparent,
        );
      },
    );
  }

//Create new bidding
  Future createBidding(
      {required int price,
      required String remarks,
      required String bookingId,
      required String icon}) async {
    try {
      Map<String, dynamic> newBid = {
        'driverId': GetStorage().read('driverId'),
        'bookingId': bookingId,
        'amount': (2.5 / 100) * price + price,
        'remarks': remarks,
        'bookingStatus': 'Pending',
        'createdAt': DateTime.now(),
        'icon': icon
      };

      await FirebaseFirestore.instance.collection('biddings').add(newBid);

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(GetStorage().read('driverId'))
          .set({
        'myBiddings': FieldValue.arrayUnion([bookingId]),
      }, SetOptions(merge: true));
      return 'Success';
    } catch (e) {
      return e;
    }
  }
}
