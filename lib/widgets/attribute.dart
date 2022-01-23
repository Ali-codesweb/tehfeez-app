import 'package:flutter/material.dart';

class Attribute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,top: 10),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Developed by\n ALIASGAR BURHANI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500]
            ),
          )),
    );
  }
}
