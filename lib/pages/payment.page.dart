import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yatayat_drivers_app/components/myButton.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);
  static const id = 'paymentMethod';

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method (भुक्तानी विधि)'),
        backgroundColor: kThemeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('बाँकी रकम तिर्ने प्रक्रियाहरु :', style: kTitleTextStyle),
              SizedBox(
                height: 10,
              ),
              Text(
                '१. तलको Qr Code स्क्यान (Scan) गर्नुहोस र तपाइलाई सजिलो लाग्ने डिजिटल भुक्तानी मध्यम जस्तै Esewa, Khalti, Phone Pay, Ime Pay आदि बाट बाँकी रहेको रकम तिर्नुहोस ।',
                style: TextStyle(color: kThemeColor, fontSize: 15),
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('./assets/qrCode.jpg'),
                  height: 200,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '२. तलको Esewa ID मा बाँकी रकम तिर्नुहोस ।',
                style: TextStyle(color: kThemeColor, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Esewa ID: 9860461944\nAccount Name: Nischal Kafle',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '३. तलको बैंक खातामा बाँकी रकम तिर्नुहोस ।',
                style: TextStyle(color: kThemeColor, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'A/C Holder Name: Nischal Kafle \nAccount Number: 08501606630690000001 \nBank Name: Nepal Bank Limited',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              MyButton(
                  title: 'Copy Bank Details',
                  icon: Icons.copy,
                  onClick: () {
                    final data = ClipboardData(
                        text:
                            'A/C Holder Name: Nischal Kafle Account Number: 08501606630690000001 Bank Name: Nepal Bank Limited');

                    Clipboard.setData(data);

                    showDialog(
                        context: context,
                        builder: (builder) => AlertDialog(
                              title: Text('Success !'),
                              content: Text(
                                  'Details Copied to clipboard successfully !'),
                            ));
                  },
                  color: Colors.green[900])
            ],
          ),
        ),
      ),
    );
  }
}
