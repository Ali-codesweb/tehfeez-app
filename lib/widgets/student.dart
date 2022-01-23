import 'package:flutter/material.dart';
import 'package:tehfeez/screens/student_detail_screen.dart';
import 'package:tehfeez/widgets/dummy_profile_pic.dart';

// ignore: must_be_immutable
class Student extends StatelessWidget {
  String name;
  int sana;
  String profilePicture;
  int id;

  Student(
      {required this.name,
      required this.profilePicture,
      required this.sana,
      required this.id});
  final shadowColor = Colors.grey[400];

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(StudentDetailScreen.routeName, arguments: {'id': id});
      },
      child: Container(
        height: height * 0.12,
        width: width * 0.85,
        margin: EdgeInsets.only(bottom: height * 0.013, top: height * 0.015),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 4.0, offset: Offset(0, 3), color: shadowColor!),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // here comes the profile picture
                DummyProfilePic((width * 0.16).toInt(), (width * 0.1).toInt(),
                    (width * 0.05).toInt(), (width * 0.05).toInt()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(sana.toString()),
                  ],
                )
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: width * 0.12,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
