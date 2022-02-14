import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
import 'package:yatayat_drivers_app/services/database.services.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class CreateBidding extends StatefulWidget {
  const CreateBidding({Key? key}) : super(key: key);
  static const id = 'createBidding';
  @override
  _CreateBiddingState createState() => _CreateBiddingState();
}

class _CreateBiddingState extends State<CreateBidding> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  String? _priceError;

  //show spinner
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    //Get data from previous page
    final data = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bidding (नयाँ बोली)'),
        backgroundColor: kThemeColor,
      ),
      body: showSpinner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Enter your final bidding price for this booking: \nयस बुकिंगको लागि अन्तिम मूल्य राख्नुहोस्:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ListTile(
                      title: Text(data['vehicleType']),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.pushNamed(context, CreateBidding.id,
                            arguments: data);
                      },
                      leading: Image(
                        image: AssetImage('./assets/icons/${data['icon']}.png'),
                      ),
                      subtitle: Text(
                          'From ${data['pickupLocation']} to ${data['destinationLocation']} (${data['noOfTrips'] == 1 ? 'One Way' : 'Two Way'}) \nPickup Date: ${data['pickupDate']} \nBooking Days: ${data['noOfDays']} days'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText:
                              'Enter Final Amount (अन्तिम भाडा सुल्क लेख्नुहोस्)',
                          labelText: 'Price',
                          errorText: _priceError,
                          errorMaxLines: 2,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.payments_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey1,
                      child: TextField(
                        controller: _remarksController,
                        decoration: InputDecoration(
                          hintText: 'Enter Remarks (अन्य जानकारी लेख्नुहोस्)',
                          labelText: 'Remarks',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.message,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyButton(
                        title: 'Submit Bidding (बोली पेश गर्नुहोस्)',
                        icon: Icons.check,
                        onClick: () {
                          setState(() {
                            if (_priceController.text.length < 3) {
                              _priceError =
                                  'Enter Valid Price (मान्य मूल्य लेख्नुहोस्)';
                            } else {
                              _priceError = null;
                            }
                          });

                          if (_priceError == null) {
                            //Create new bidding
                            showDialog(
                              context: context,
                              builder: (ctxt) => AlertDialog(
                                title: Text('Confirm Bidding ?'),
                                content: Text(
                                    'तपाइको बोली पेश हुन गइरहेको छ | यसपछि तपाइले भाडा रकम बदलन सक्नुहुन्न | के यो बोली पेश गर्दा हुन्छ ? '),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No (नगर्नुहोस्)',
                                      style: TextStyle(color: Colors.red[900]),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green[900],
                                    ),
                                    onPressed: () async {
                                      try {
                                        //Create a new bidding
                                        Navigator.pop(ctxt);
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        await Database().createBidding(
                                            price: int.parse(
                                                _priceController.text),
                                            remarks: _remarksController.text,
                                            bookingId: data['id'],
                                            icon: data['icon']);

                                        //Store driver details in local storage
                                        DocumentSnapshot documentSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('drivers')
                                                .doc(GetStorage()
                                                    .read('driverId'))
                                                .get();

                                        if (documentSnapshot.exists) {
                                          dynamic doc = documentSnapshot.data();

                                          await GetStorage().write(
                                              'driverPendingAmount',
                                              doc['pendingAmount']);
                                          await GetStorage().write(
                                              'driverBiddings',
                                              doc['myBiddings']);
                                        }

                                        setState(() {
                                          showSpinner = false;
                                        });
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (alertContext) =>
                                              AlertDialog(
                                            title: Text('Bidding Success !!'),
                                            content: Text(
                                                'You bidding has been succesfully placed. (तपाइँको बोली सफलतापूर्वक पेश भएको छ।)'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(alertContext);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Ok (ठिक छ)'))
                                            ],
                                          ),
                                        );
                                      } catch (e) {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (alertContext) =>
                                              AlertDialog(
                                            title: Text('Bidding Error !!'),
                                            content: Text(
                                                'Error occured while placing your bid. Please try again later ! (तपाईंको बोली राख्ने क्रममा त्रुटि भयो। फेरी प्रयास गर्नु होला !)'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(alertContext);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Ok (ठिक छ)'))
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Yes (हुन्छ)',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        color: Colors.green[900])
                  ],
                ),
              ),
            )),
    );
  }
}
