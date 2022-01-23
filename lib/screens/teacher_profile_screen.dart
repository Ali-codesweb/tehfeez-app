import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/add_student_screen.dart';
import '../widgets/custom_size_button.dart';
import '../widgets/dummy_profile_pic.dart';

class TeacherProfileScreen extends StatefulWidget {
  static const routeName = '/teacher-profile';

  @override
  _TeacherProfileScreenState createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  var _isInit = false;
  var _loading = false;
  var _profileUpdateLoading = false;
  var _editMode = false;
  var _teacherName;
  var _mobileNumber;
  var _email;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _loading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .fetchUserDetails(context)
          .then((_) {
        setState(() {
          _loading = false;
          _teacherName = TextEditingController(
              text: Provider.of<Auth>(context, listen: false).teacher.name);
          _email = TextEditingController(
              text: Provider.of<Auth>(context, listen: false).teacher.email);
          _mobileNumber = TextEditingController(
              text: Provider.of<Auth>(context, listen: false)
                  .teacher
                  .mobileNumber);
        });
      });

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    final authProvider = Provider.of<Auth>(context);
    final _teacher = authProvider.teacher;
    return Scaffold(
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: height * 0.09,
                    left: width * 0.02,
                    right: width * 0.03),
                child: Column(children: [
                  Column(
                    children: [
                      DummyProfilePic(
                          (width * 0.4).toInt(), (width * 0.2).toInt()),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: width * 0.5,
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: width * 0.04, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                          enabled: _editMode,
                          controller: _teacherName,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: height * 0.33,
                    margin:
                        EdgeInsets.only(left: width * 0.05, top: height * 0.04),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              'Email : ',
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Colors.grey[600],
                              ),
                            ),
                            Container(
                              width: width * 0.6,
                              // height: height * 0.055,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.grey[600],
                                ),
                                enabled: _editMode,
                                controller: _email,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Mobile no.',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: width * 0.034),
                            ),
                            Container(
                              width: 100,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.grey[600],
                                ),
                                enabled: _editMode,
                                controller: _mobileNumber,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Total students : ${_teacher.students.toString()}',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: width * 0.034),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomSizeButton(
                              performingAction: () {
                                Navigator.of(context)
                                    .pushNamed(AddStudentScreen.routeName);
                              },
                              icon: Text(
                                'Add Student',
                                style: TextStyle(fontSize: width * 0.032),
                                textAlign: TextAlign.center,
                              ),
                              height: height * 0.05,
                              width: width * 0.3,
                              color: Theme.of(context).primaryColor,
                            ),
                            _profileUpdateLoading
                                ? CircularProgressIndicator()
                                : CustomSizeButton(
                                    performingAction: () {
                                      if (_editMode) {
                                        print('edit now !!');

                                        setState(() {
                                          _profileUpdateLoading = true;
                                        });
                                        authProvider.editTeacherProfile({
                                          'email': _email.text,
                                          'name': _teacherName.text,
                                          'mobile_number': _mobileNumber.text
                                        }, context).then((_) {
                                          setState(() {
                                            _profileUpdateLoading = false;
                                          });
                                        });
                                      }
                                      print('dont edit now !!');
                                      setState(() {
                                        _editMode = !_editMode;
                                      });
                                      // Navigator.of(context)
                                      //     .pushNamed(AddStudentScreen.routeName);
                                    },
                                    icon: _editMode
                                        ? Text('Save Profile',
                                            style: TextStyle(
                                                fontSize: width * 0.032),
                                            textAlign: TextAlign.center)
                                        : Text(
                                            'Edit Profile',
                                            style: TextStyle(
                                                fontSize: width * 0.032),
                                          ),
                                    height: height * 0.05,
                                    width: width * 0.3,
                                    color: Theme.of(context).primaryColor,
                                  ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CustomSizeButton(
                            performingAction: () {
                              authProvider.logout(context);
                            },
                            icon: Text('Logout',
                                style: TextStyle(fontSize: width * 0.032),
                                textAlign: TextAlign.center),
                            height: height * 0.05,
                            width: width * 0.3,
                            color: Colors.teal,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
    );
  }
}
