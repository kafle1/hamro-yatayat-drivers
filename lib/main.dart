import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/pages/createBidding.dart';
import 'package:yatayat_drivers_app/pages/feedback.page.dart';
import 'package:yatayat_drivers_app/pages/home.page.dart';
import 'package:yatayat_drivers_app/pages/signin.page.dart';
import 'package:yatayat_drivers_app/pages/webview.page.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const YatayatDrivers());
}

class YatayatDrivers extends StatefulWidget {
  const YatayatDrivers({Key? key}) : super(key: key);

  @override
  _YatayatDriversState createState() => _YatayatDriversState();
}

class _YatayatDriversState extends State<YatayatDrivers> {
  final db = GetStorage();
  @override
  void initState() {
    super.initState();

    //Get the vehicles of the driver
    if (db.read('driverVehicles') == null) {
      final driverId = db.read('driverId');
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          dynamic data = documentSnapshot.data();
          //Store vehicles local db
          db.write('driverVehicles', data['vehicleType']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kThemeColor),
      home: Home(),
      initialRoute: db.read('driverId') != null ? Home.id : Signin.id,
      routes: {
        Home.id: (context) => Home(),
        ShowWebsite.id: (context) => ShowWebsite(),
        Signin.id: (context) => Signin(),
        FeedbackContact.id: (context) => FeedbackContact(),
        CreateBidding.id: (context) => CreateBidding(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
