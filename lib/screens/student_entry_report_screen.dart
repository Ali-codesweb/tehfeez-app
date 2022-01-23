import 'package:flutter/material.dart';

class StudentEntryReportScreen extends StatelessWidget {
  static const routeName = '/student-entry-report-screen';
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    print(arguments);
    return Scaffold(
      body: Container(),
    );
  }
}
