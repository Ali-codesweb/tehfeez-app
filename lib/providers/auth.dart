import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tehfeez/models/auth.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'package:tehfeez/widgets/custom_alert.dart';

class Auth with ChangeNotifier {
  // static const URL = 'http://192.168.218.220:8000/api/';
  static const URL = 'https://tehfeez.herokuapp.com/api/';

  TeacherModel _teacher = TeacherModel(
      name: '',
      username: '',
      email: '',
      id: 1,
      students: 0,
      token: '',
      mobileNumber: '');

  TeacherModel get teacher {
    return _teacher;
  }

  List<StudentModel> _students = [

  ];

  List<StudentModel> get students {
    return _students;
  }

  // Map<String, dynamic> _userData = {'username': null, 'id': null, 'token': ''};

  logout(BuildContext ctx) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _students = [];

    Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);

    notifyListeners();
  }
  var responesOfStudents ;

  Future<void> fetchStudents(BuildContext ctx) async {
    try {
      _students = [];
      final prefs = await SharedPreferences.getInstance();
      final _data = prefs.get('token');
      _teacher.token = _data.toString();
      _teacher.name = prefs.get('name').toString();
      if (_data != null || _data != '') {
        final response = await http.get(Uri.parse(URL + 'fetch-students/'),
            headers: {'Authorization': 'Bearer $_data'});
        final data = json.decode(response.body);
        responesOfStudents=data;
        if (response.statusCode >= 400) {
          await showDialog(
              context: ctx,
              builder: (ctx) => CustomAlert(ctx, 'Error', 'Sesion Expired'));
          Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
        } else {
          print(data);
          data.forEach((e) {
            _students.add(
              StudentModel(
                id: e['id'],
                gender: e['gender'],
                name: e['name'],
                teacher: e['teacher'],
                mobileNumber: e['mobile_number'],
                email: e['email'],
                dateJoined: DateTime.parse(e['date_joined']),
                profilePicture: e['profile_picture'],
                currentSana: e['current_sana'],
                dateOfBirth: DateTime.parse(e['dob']),
                currentJadeedSurat: e['current_jadeed_surat'],
                avgJuzhali: e['avg_juzhali'],
                avgMurajah: e['avg_murajah'],
                avgAttendance: e['avg_attendance'],
                currentJadeedSuratAyat: e['current_jadeed_surat_ayat'],
              ),
            );
          });
        }
      } else {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, 'Error', 'Sesion Expired'));
        Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
      }
    } catch (error) {
      await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, 'Error', 'Sesion Expired'));
        Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName)
    }
    notifyListeners();
  }

  Future<void> login(String? username, String? password, BuildContext ctx) async {
    if (username == null || password == null) return;
    try {
      final response = await http.post(Uri.parse(URL + 'login/'),
          body: {'username': username, 'password': password});
      final data = json.decode(response.body);
      print(data);
      if (response.statusCode >= 400) {
        String message =
            data['detail'] != null ? data['detail'] : 'Something went wrong';
        await showDialog(
            context: ctx,
            builder: (ctx) {
              return CustomAlert(
                ctx,
                message,
                'Error',
              );
            });
      } else {
        print(data);
        _teacher.name = data['name'];
        _teacher.token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('name', data['name']);
        Navigator.of(ctx).pushReplacementNamed(HomeScreen.routeName);
        notifyListeners();
      }
    } catch (error) {
      print('we got an error');
    }
  }

  Future fetchUserDetails(BuildContext ctx) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final _data = prefs.get('token');

      final response = await http.get(Uri.parse(URL + 'fetch-teacher-details/'),
          headers: {'Authorization': 'Bearer $_data'});
      final data = json.decode(response.body);

      if (response.statusCode >= 400) {
        await showDialog(
            context: ctx,
            builder: (ctx) {
              return CustomAlert(
                ctx,
                'Session Expired. Login again',
                'Error',
              );
            });
        Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
      } else {
      print(data);
        _teacher.email = data['email'];
        _teacher.mobileNumber= data['mobile_number'];
        _teacher.id = data['id'];
        _teacher.students = data['students_count'];
        _teacher.username = data['username'];
        _teacher.name = data['first_name'];
      }
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future editTeacherProfile(Map _data, BuildContext ctx) async {
    try {
      final response = await http.post(
        Uri.parse(URL + 'update-details/'),
        body: json.encode(_data),
        headers: {
          'Authorization': 'Bearer ${_teacher.token}',
          'Content-Type': 'Application/json'
        },
      );

      final _body = json.decode(response.body);

      if (response.statusCode >= 400) {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, _body['message'], 'Error'));
      } else {
        await showDialog(
            context: ctx,
            builder: (ctx) => CustomAlert(ctx, _body['message'], 'Success'));
        _teacher.name = _data['name'];
        Navigator.of(ctx).pushReplacementNamed(HomeScreen.routeName);
      }

      notifyListeners();
    } catch (e) {
      await showDialog(
          context: ctx,
          builder: (ctx) => CustomAlert(ctx, 'Some error occurred', 'Error'));
    }
  }
}
