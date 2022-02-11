import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class buildSheet extends StatefulWidget {
  final Map data;
  const buildSheet({Key? key, required this.data}) : super(key: key);

  @override
  _buildSheetState createState() => _buildSheetState();
}

class _buildSheetState extends State<buildSheet> {
  @override
  Widget build(BuildContext context) {
    Map biddingDetails = widget.data;
    return makeDismissible(
      child: DraggableScrollableSheet(
        minChildSize: 0.3,
        initialChildSize: 0.6,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
          padding: EdgeInsets.all(15),
          child: ListView(
            controller: controller,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 140),
                height: 7,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Booking Details (बुकिङ विवरण):',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kThemeColor),
              ),
              SizedBox(
                height: 10,
              ),
              GetBiddingDetails(
                data: biddingDetails,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}

class GetBiddingDetails extends StatelessWidget {
  final Map data;
  const GetBiddingDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference booking = FirebaseFirestore.instance
        .collection('users')
        .doc(data['customerDocId'])
        .collection('bookings');
    return FutureBuilder<DocumentSnapshot>(
      future: booking.doc(data['bookingId']).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Name (ग्राहकको नाम):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Booking ID (बुकिङ आईडी):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Vehicle Type (गाडीको प्रकार):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Pickup Location (चढ्ने स्थान):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Pickup Date (चढ्ने मिति):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Destination (गन्तव्य स्थान):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'No of Trip (ट्रीप संख्या):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Booking Days (बुकिङ दिन):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Phone No. (फोन नंबर):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Total Price (पुरा रकम/पैसा):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Driver\'s Name (ड्राइभरको नाम):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Driver\'s No. (ड्राइभरको नम्बर):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Vehicle No. (गाडी नम्बर):',
                        style: kDetailsLabelStyle,
                      ),
                      Text(
                        'Booking Status (बुकिंग स्थिति):',
                        style: kDetailsLabelStyle,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['bookingId'].toString(),
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['vehicleType'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['pickupLocation'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['pickupDate'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['destinationLocation'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['noOfTrips'] == '1' ? 'One Way' : 'Two Way',
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['noOfDays'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['phoneNumber'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        'Rs. ${data['amount']}',
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['driverName'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['driverNumber'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['vehicleNumber'],
                        style: TextStyle(height: 1.36),
                      ),
                      Text(
                        data['status'],
                        style: TextStyle(height: 1.36),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        }

        return Text("Loading ...");
      },
    );
  }
}
