import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
import 'package:yatayat_drivers_app/pages/home.page.dart';
import 'package:yatayat_drivers_app/services/database.services.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);
  static const id = 'signin';
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _driverIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final data = GetStorage();
  bool showSpinner = false;

  String? _driverIdError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: showSpinner
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: kThemeColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                      ),
                      Image(
                        image: AssetImage('./assets/dark-logo.png'),
                        height: 70,
                      ),
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      Text(
                        'Hamro Yatayat Drivers',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: AssetImage('./assets/signin.png'),
                        width: 280,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _driverIdController,
                          decoration: InputDecoration(
                            hintText: 'Enter Driver ID (चालक आईडी लेख्नुहोस्)',
                            labelText: 'Driver ID',
                            errorText: _driverIdError,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.perm_identity),
                          ),
                          maxLength: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: MyButton(
                            title: 'Sign In (भित्र प्रवेश गर्नुहोस्)',
                            icon: Icons.login,
                            onClick: () async {
                              //Check if driver exists in the database
                              dynamic driverExists = await Database()
                                  .driverExists(
                                      driverId: _driverIdController.text);

                              setState(() {
                                if (_driverIdController.text.length < 4) {
                                  _driverIdError =
                                      'Invalid Driver ID (गलत चालक आईडी)';
                                } else if (!driverExists) {
                                  _driverIdError =
                                      'Driver does not exists ! (यो चालक हाम्रो डाटाबेसमा छैन।)';
                                } else {
                                  _driverIdError = null;
                                }
                              });
                              if (_driverIdError == null) {
                                //Show spinner
                                showSpinner = true;

                                //Get the driver id entered by the user
                                String driverId = _driverIdController.text;

                                //Create anonymous signin and save in local db
                                await FirebaseAuth.instance.signInAnonymously();

                                //Store driver details in local storage
                                DocumentSnapshot documentSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('drivers')
                                        .doc(driverId)
                                        .get();

                                if (documentSnapshot.exists) {
                                  dynamic doc = documentSnapshot.data();
                                  await data.write(
                                      'driverVehicles', doc['vehicleType']);
                                  await data.write('driverPendingAmount',
                                      doc['pendingAmount']);
                                  await data.write(
                                      'driverBiddings', doc['myBiddings']);
                                }
                                //Store driver id in local storage
                                data.write('driverId', driverId);

                                //Stop spinner
                                showSpinner = false;

                                //Go to home screen
                                Navigator.popAndPushNamed(context, Home.id);
                              }
                            },
                            color: kThemeColor),
                      )
                    ],
                  ),
                ),
              ));
  }
}
