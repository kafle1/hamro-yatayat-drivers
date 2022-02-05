import 'package:flutter/material.dart';
import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class MyButton extends StatelessWidget {
  String title;
  IconData icon;
  Function() onClick;
  Color? color;
  MyButton(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onClick,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onClick,
        icon: Icon(icon),
        label: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: color),
      ),
    );
  }
}
