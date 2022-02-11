import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/components/availableBiddings.dart';
import 'package:yatayat_drivers_app/components/biddingHistoyCards.dart';
import 'package:yatayat_drivers_app/components/notices.dart';
import 'package:yatayat_drivers_app/pages/feedback.page.dart';
import 'package:yatayat_drivers_app/pages/profile.page.dart';
import 'package:yatayat_drivers_app/pages/signin.page.dart';
import 'package:yatayat_drivers_app/pages/webview.page.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    //Check if driver has pending amount to pay
    //If yes show a popup as a remainder to pay the due amount
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(GetStorage().read('driverId'))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map? data = documentSnapshot.data() as Map;

      if (data['pendingAmount'] > 0) {
        GetStorage().write('driverPendingAmount', data['pendingAmount']);
        showDialog(
          context: context,
          builder: (ctxt) => AlertDialog(
            title: Text('Pending Amount Due !!'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[900],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ShowWebsite.id,
                      arguments: 'https://yatayat.netlify.app/pending-due');
                },
                child: Text(
                  'Pay Now (अहिले तिर्नुहोस्)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'I Will Pay Later (म पछि तिर्नेछु)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            content: Text(
                'You have pending amount Rs. ${data['pendingAmount']} to pay to Yatayat, which is from your previous booking. Please pay it on time so that you can place your bid for next booking. Thank you ! \n\nतपाईंको रकम रु.${data['pendingAmount']} यातायातलाई तिर्न बाँकी छ , जुन तपाइँको अघिल्लो बुकिङबाट हो। कृपया यसलाई समयमै तिर्नुहोस् ताकि तपाइँ अर्को बुकिङको लागि आफ्नो बोली राख्न सक्नुहुन्छ। धन्यवाद !'),
          ),
        );
      }
    });
  }

  final data = GetStorage();
  //Handle spinner event
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    //Get the current driver's driver is from local storage
    final driverId = data.read('driverId');

    return showSpinner
        ? CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: kThemeColor,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Hamro Yatayat'),
              backgroundColor: kThemeColor,
              actions: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    //Get driver details from firebase
                    FirebaseFirestore.instance
                        .collection('drivers')
                        .doc(driverId)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      //Stop the spinner
                      setState(() {
                        showSpinner = false;
                      });

                      //Open drivers profile page passing the data
                      Navigator.pushNamed(context, Profile.id,
                          arguments: documentSnapshot.data());
                    });
                  },
                  icon: Icon(Icons.person),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, FeedbackContact.id);
                  },
                  icon: Icon(Icons.feedback),
                ),
                IconButton(
                  onPressed: () async {
                    //Remove cache from db
                    data.remove('driverId');

                    //Signout the user
                    await FirebaseAuth.instance.signOut();

                    //Open signin page
                    Navigator.popAndPushNamed(context, Signin.id);
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bidding History (मेरो बोलीहरु):',
                      style: kTitleTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BiddingHistoryCard(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Notices (सुचनाहरु):',
                      style: kTitleTextStyle,
                    ),
                    Notices(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Available Bookings (उपलब्ध बुकिङ):',
                      style: kTitleTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ShowAvailableBiddings()
                  ],
                ),
              ),
            ),
          );
  }
}
