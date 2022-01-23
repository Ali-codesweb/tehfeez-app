import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tehfeez/models/auth.dart';
import 'package:tehfeez/screens/home_screen.dart';
import 'package:tehfeez/widgets/custom_alert.dart';

class StudentProvider with ChangeNotifier {
  var _token;

  update(token) {
    _token = token;
  }

// https://tehfeez.herokuapp.com/
  // static const URL = 'http://192.168.218.220:8000/api/';
  static const URL = 'https://tehfeez.herokuapp.com/api/';

  Future addStudent(Map _data, BuildContext ctx) async {
    try {
      final response = await http.post(Uri.parse(URL + 'create-student/'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'Application/json'
          },
          body: json.encode(_data));

      final body = json.decode(response.body);
      print(body);
      if (response.statusCode >= 400) {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, body['message'], 'Error'));
      } else {
        Navigator.of(ctx).pushReplacementNamed(HomeScreen.routeName);
      }
    } catch (e) {
      await showDialog(
          context: ctx,
          builder: (ctx) => CustomAlert(ctx, 'Some error occurred', 'Error'));
    }
  }

  Future deleteStudent(int id, BuildContext ctx) async {
    try {
      final response = await http.post(Uri.parse(URL + 'delete-student/'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'Application/json'
          },
          body: json.encode({'id': id}));

      final _data = json.decode(response.body);

      if (response.statusCode >= 400) {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, _data['message'], 'Error'));
      } else {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, _data['message'], 'Success'));

        Navigator.of(ctx).pushReplacementNamed(HomeScreen.routeName);
      }
    } catch (e) {
      await showDialog(
          context: ctx,
          builder: (ctx) => CustomAlert(ctx, 'Some error occurred', 'Error'));
    }
  }

  Future editStudentDetails(StudentModel _data, BuildContext ctx) async {
    final response = await http.post(Uri.parse(URL + 'edit-student/'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'Application/json'
        },
        body: json.encode({
          'name': _data.name,
          'gender': _data.gender,
          'email': _data.email,
          'id': _data.id
        }));

    final body = json.decode(response.body);

    if (response.statusCode <= 400) {
      print(response.body);
      await showDialog(
          context: ctx,
          builder: (ctx) => CustomAlert(ctx, body['message'], 'Success'));
    } else {
      await showDialog(
          context: ctx,
          builder: (ctx) => CustomAlert(ctx, body['message'], 'Error'));
    }
  }
}
