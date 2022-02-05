import 'package:flutter/material.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
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
  String? _remarksError;

  @override
  Widget build(BuildContext context) {
    //Get data from previous page
    final data = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bidding (नयाँ बोली)'),
        backgroundColor: kThemeColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Bidding for this booking: ',
                style: kTitleTextStyle,
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
                    errorMaxLines: 3,
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
                    errorText: _remarksError,
                    errorMaxLines: 3,
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
                      if (_priceController.text.length < 2) {
                        _priceError =
                            'Enter Valid Price (मान्य मूल्य लेख्नुहोस्)';
                      } else {
                        _priceError = null;
                      }
                    });
                  },
                  color: Colors.green[900])
            ],
          ),
        ),
      )),
    );
  }
}
