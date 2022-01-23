import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student.dart';
import '../widgets/custom_size_button.dart';
import '../widgets/dummy_profile_pic.dart';

class AddStudentScreen extends StatefulWidget {
  static const routeName = '/add-student';

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  var _gender = true;
  var _loading = false;
  final _muhaffizController = TextEditingController(text: 'Aliasgar Burhani');
  final _nameController = TextEditingController(text: '');
  final _mobileNumberController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');

  DateTime _dob = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(children: [
            Column(
              children: [
                // DummyProfilePic(190, 85),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    'Add Student',
                    style: TextStyle(fontSize: 25, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            Container(
              height: 340,
              margin: EdgeInsets.only(left: 20, top: 40),
              width: 300,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Muhaffiz',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: false,
                            controller: _muhaffizController,
                          ),
                          width: 200,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          child: TextFormField(
                            controller: _nameController,
                          ),
                          width: 200,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mobile Number',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          child: TextFormField(
                            controller: _mobileNumberController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            // ons
                          ),
                          width: 150,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender : ${_gender ? "Male" : "Female"}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Switch(
                          value: _gender,
                          onChanged: (val) {
                            setState(() {
                              _gender = val;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          child: TextFormField(
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                          ),
                          width: 150,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date of Birth',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        _dob.day != DateTime.now().day
                            ? Text('${_dob.day} / ${_dob.month} / ${_dob.year}')
                            : SizedBox(),
                        CustomSizeButton(
                          performingAction: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime(2001),
                              firstDate: DateTime(2001),
                              lastDate: DateTime.now(),
                            ).then((value) {
                              if (value == null) return;
                              setState(() {
                                _dob = value;
                              });
                            });
                          },
                          icon: Text(
                            'Pick up a date',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          height: 40,
                          width: 90,
                          color: Colors.teal,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 40, bottom: 20),
            //   child: DummyProfilePic(170, 0),
            // ),
            // CustomSizeButton(
            //   performingAction: () {},
            //   icon: Text(
            //     'Pick a profile Image',
            //     style: TextStyle(
            //       fontSize: 12,
            //     ),
            //   ),
            //   height: 40,
            //   width: 170,
            //   color: Theme.of(context).primaryColor,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: CustomSizeButton(
                performingAction: () {
                  setState(() {
                    _loading = true;
                  });
                  Map _data = {
                    'gender': _gender,
                    'name': _nameController.text,
                    'teacher': _muhaffizController.text,
                    'mobile_number': _mobileNumberController.text,
                    'email': _emailController.text,
                    'dob': _dob.toIso8601String()
                  };
                  Provider.of<StudentProvider>(context, listen: false)
                      .addStudent(_data, context)
                      .then((_) {
                    setState(() {
                      _loading = false;
                    });
                  });
                },
                icon: _loading
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        'Create a student',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                height: 45,
                width: 200,
                color: Colors.teal,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
