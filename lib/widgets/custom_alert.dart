import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAlert extends StatelessWidget {
  String message;
  String head ;
  BuildContext ctx;

  CustomAlert(this.ctx, this.message, this.head);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(head),
      content: Text(message),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text('Okay'),
        ),
      ],
    );
  }
}
