import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

import 'bottomSheet.dart';

class BiddingHistoryCard extends StatefulWidget {
  const BiddingHistoryCard({Key? key}) : super(key: key);

  @override
  _BiddingHistoryCardState createState() => _BiddingHistoryCardState();
}

class _BiddingHistoryCardState extends State<BiddingHistoryCard> {
  final Stream<QuerySnapshot> _biddingStream = FirebaseFirestore.instance
      .collection('biddings')
      .where('driverId', isEqualTo: GetStorage().read('driverId'))
      .orderBy('createdAt', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _biddingStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading ...");
        }

        if (!snapshot.hasData) {
          return Text('No data found');
        }
        return SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return BidCard(
                data: data,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class BidCard extends StatelessWidget {
  final Map data;
  const BidCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Check if the bidding status is pending or not
        if (data['bookingStatus'] == 'Confirmed') {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => buildSheet(
                    data: data,
                  ));
        } else {
          showDialog(
            context: context,
            builder: (ctxt) => AlertDialog(
              title: Text('Please wait !'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green[900],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok ( ठिक छ )',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              content: Text(
                  'Your bidding status is ${data['bookingStatus']}. You will get all the details of the booking and customer once the customer confirms your bid.'),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[300],
        ),
        margin: EdgeInsets.only(right: 15),
        width: 110,
        height: 110,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat.MMMd().add_Hm().format(data['createdAt'].toDate()),
                style: TextStyle(fontSize: 11),
              ),
              Image(
                image: AssetImage('./assets/icons/${data['icon']}.png'),
                height: 50,
              ),
              Text(
                'Rs. ${data['amount']}',
                style: TextStyle(color: kThemeColor),
              ),
              Text(
                '${data['bookingStatus']}',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
