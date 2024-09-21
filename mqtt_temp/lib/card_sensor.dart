import 'package:flutter/material.dart';

class CardSensor extends StatelessWidget {
  const CardSensor(
      {super.key,
      required this.iconData,
      required this.sensor,
      required this.value});

  final IconData iconData;
  final String sensor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Container(
          child: GestureDetector(
        onTap: () {},
        child: Container(
            child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.lightBlue,
                ),
                Text(value),
                Text(sensor)
              ],
            ),
          ),
        )),
      )),
    );
  }
}
