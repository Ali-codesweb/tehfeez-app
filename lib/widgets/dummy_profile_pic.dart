import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DummyProfilePic extends StatelessWidget {
  int size;
  // ignore: non_constant_identifier_names
  int icon_size;
  int marginLeft;
  int marginRight;
  DummyProfilePic(this.size, this.icon_size,
      [this.marginLeft = 0, this.marginRight = 0]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: double.parse(marginLeft.toString()),
        right: double.parse(marginRight.toString()),
        ),
      width: double.parse(size.toString()),
      height: double.parse(size.toString()),
      child: Icon(
        Icons.person,
        size: double.parse(icon_size.toString()),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[400],
      ),
    );
  }
}
