import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/components/availableBiddings.dart';
import 'package:yatayat_drivers_app/components/biddingHistoyCards.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
import 'package:yatayat_drivers_app/components/notices.dart';
import 'package:yatayat_drivers_app/pages/feedback.page.dart';
import 'package:yatayat_drivers_app/pages/signin.page.dart';
import 'package:yatayat_drivers_app/pages/webview.page.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final data = GetStorage();
  @override
  Widget build(BuildContext context) {
    final driverId = data.read('driverId');
    return Scaffold(
      appBar: AppBar(
        title: Text('Hamro Yatayat'),
        backgroundColor: kThemeColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ShowWebsite.id,
                  arguments: 'https://yatayat-drivers.netlify.app/$driverId');
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

              //Open signi page
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
