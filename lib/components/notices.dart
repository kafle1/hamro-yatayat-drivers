import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';
import 'package:intl/intl.dart';

class Notices extends StatefulWidget {
  const Notices({Key? key}) : super(key: key);

  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  //Collection reference
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('driverNotices')
      .orderBy('createdAt', descending: true)
      .limit(3)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }
        if (!snapshot.hasData) {
          return Text('No notice available');
        }

        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              title: Text(
                data['title'],
                style: TextStyle(color: kThemeColor),
              ),
              subtitle: Text(data['body']),
              trailing: Text(DateFormat.MMMd()
                  .add_Hm()
                  .format(data['createdAt'].toDate())),
            );
          }).toList(),
        );
      },
    );
  }
}
