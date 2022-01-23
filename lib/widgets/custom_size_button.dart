import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSizeButton extends StatelessWidget {
  final VoidCallback performingAction;
  var icon;
  double width;
  double height;
  Color color;
  bool enabled;
  CustomSizeButton(
      {required this.performingAction,
      required this.icon,
      required this.height,
      required this.width,
      required this.color,
      this.enabled = true});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: height),
      child: ElevatedButton(
        onPressed: enabled ? performingAction : null,
        child: icon,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 12),
          ),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
    );
  }
}
