import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
import 'package:yatayat_drivers_app/pages/feedback.page.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const id = 'profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //Catch the passed data
    final data = ModalRoute.of(context)!.settings.arguments as Map;

    //Get drivers pending amount
    String pendingAmount = data['pendingAmount'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: kThemeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyButton(
                  title:
                      'Pending Amount (बाँकी रहेको रकम) : Rs. $pendingAmount',
                  icon: Icons.payments,
                  onClick: () {
                    if (pendingAmount != 0) {
                      // Navigator.pushNamed(context, PaymentMethods.id);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('All Clear'),
                                content: Text(
                                    'You don\'t have pending amount left !'),
                              ));
                    }
                  },
                  color: pendingAmount != '0'
                      ? Colors.red[900]
                      : Colors.green[900]),
              SizedBox(
                height: 10,
              ),
              Text(
                'Pay your pending amount on time ! (आफ्नो बाँकी रकम समयमै तिर्नुहोस्!)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Details: ',
                style: kTitleTextStyle,
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['name']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Name (नाम) :',
                  border: OutlineInputBorder(),
                  enabled: false,
                  iconColor: kThemeColor,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['id']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'ID (आइडी) :',
                    border: OutlineInputBorder(),
                    enabled: false,
                    prefixIcon: Icon(Icons.card_membership)),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['location']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'LOCATION (स्थान) :',
                  border: OutlineInputBorder(),
                  enabled: false,
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['phoneNumber']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PHONE NUMBER (फोन नंबर) :',
                  border: OutlineInputBorder(),
                  enabled: false,
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['driverName']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'DRIVER\'S NAME (ड्राइभरको नाम) :	',
                    border: OutlineInputBorder(),
                    enabled: false,
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['driverNumber']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'DRIVER\'S NUMBER (ड्राइभरको नंबर) :	',
                  border: OutlineInputBorder(),
                  enabled: false,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(text: data['vehicleNumber']),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'VEHICLE NUMBER (गाडी नंबर) :',
                  border: OutlineInputBorder(),
                  enabled: false,
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController(
                    text: data['bookingsCompleted'].toString()),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'BOOKINGS COMPLETED (अहिलेसम्म सम्पन्न भएका बुकिङहरु) :	',
                  border: OutlineInputBorder(),
                  enabled: false,
                  prefixIcon: Icon(Icons.check),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller:
                    TextEditingController(text: data['vehicleType'].toString()),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'My VEHICLES (मेरो गाडीहरु) :',
                    border: OutlineInputBorder(),
                    enabled: false,
                    prefixIcon: Icon(Icons.directions_car_filled)),
                maxLines: 2,
              ),
              SizedBox(
                height: 12,
              ),
              MyButton(
                  title: 'Edit Details (विवरणहरू सच्याउनुहोस्)',
                  icon: Icons.edit,
                  onClick: () {
                    Navigator.popAndPushNamed(context, FeedbackContact.id);
                  },
                  color: kThemeColor)
            ],
          ),
        ),
      ),
    );
  }
}
