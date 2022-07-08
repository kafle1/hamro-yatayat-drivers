import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
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

  //Create a token in db
  Future createToken({required String uid, required String token}) async {
    try {
      await FirebaseFirestore.instance
          .collection('tokens')
          .doc(uid)
          .set({'id': uid, 'token': token});
    } catch (e) {
      return e;
    }
  }

  //Send notification to the customer
  Future sendBidNotification({required String id}) async {
    try {
      var info =
          await FirebaseFirestore.instance.collection('tokens').doc(id).get();
      Map<String, dynamic>? token = info.data();

      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAbFMLzsw:APA91bHfAEwznjJUX5mY31SlsA0UafLrKI_wdhWH1noQCRSddc_p1KmROT79UdVnf8XWM27-q9vddtTiQYWJ7VH71RgNoezGsNIXu7k8j0OrKWVPJgXl7hWzrFTeErYOZlG70T5BlnZ2 '
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
      request.body = json.encode({
        "registration_ids": [token!['token']],
        "notification": {
          "title": "New Booking Price Updated ! Vehicle Available !",
          "body":
              "Someone has placed their bidding for your booking. Check your app to see the price and confirm your booking. कसैले तपाईंको बुकिङको लागि आफ्नो बोली राखेको छ। मूल्य हेर्न र आफ्नो बुकिङ कन्फर्म गर्न आफ्नो एप हेर्नुहोस् |",
          "sound": "default"
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return response.reasonPhrase;
      }
    } catch (e) {
      return e;
    }
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
