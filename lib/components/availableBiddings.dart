import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/pages/createBidding.dart';
import 'package:yatayat_drivers_app/pages/home.page.dart';
import 'package:yatayat_drivers_app/pages/webview.page.dart';

class ShowAvailableBiddings extends StatefulWidget {
  const ShowAvailableBiddings({Key? key}) : super(key: key);

  @override
  _ShowAvailableBiddingsState createState() => _ShowAvailableBiddingsState();
}

List vehicles = GetStorage().read('driverVehicles');

class _ShowAvailableBiddingsState extends State<ShowAvailableBiddings> {
//Database references
  final Stream<QuerySnapshot> _availableBiddingsStream = FirebaseFirestore
      .instance
      .collection('availableBiddings')
      .where('vehicleType', whereIn: vehicles)
      .orderBy('bookingDate', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _availableBiddingsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }
        if (!snapshot.hasData) {
          return Text(
              "No bookings are available right now ! ( अहिले कुनै बुकिङहरु उपलब्ध छैनन्! )");
        }
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            return ListTile(
              //check if user has already added placed booking for this order
              enabled:
                  !GetStorage().read('driverBiddings').contains(data['id']),
              title: Text(data['vehicleType']),
              isThreeLine: true,
              onTap: () async {
                if (await GetStorage().read('driverPendingAmount') > 0) {
                  //If driver has pending amount to pay
                  Navigator.pushNamed(context, ShowWebsite.id,
                      arguments: 'https://yatayat.netlify.app/pending-due');
                } else {
                  Navigator.pushNamed(context, CreateBidding.id,
                          arguments: data)
                      .then((value) {
                    //Re-builds the screen
                    setState(() {});
                  });
                }
              },
              leading: Image(
                image: AssetImage('./assets/icons/${data['icon']}.png'),
              ),
              subtitle: Text(
                  'From ${data['pickupLocation']} to ${data['destinationLocation']} (${data['noOfTrips'] == '1' ? 'One Way' : 'Two Way'}) \nPickup Date: ${data['pickupDate']} \nBooking Days: ${data['noOfDays']} days'),
            );
          }).toList(),
        );
      },
    );
  }
}
