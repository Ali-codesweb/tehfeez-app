import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../models/auth.dart';
import '../providers/auth.dart';
import '../providers/student.dart';
import '../screens/student_report_screen.dart';
import '../widgets/custom_chart.dart';
import '../widgets/custom_size_button.dart';
import '../widgets/dummy_profile_pic.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDetailScreen extends StatefulWidget {
  static const routeName = '/student-detail';

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  var _isEdit = false;
  var _isInit = true;
  var _loading = false;
  var _arguments;
  var authProvider;
  late TextEditingController _studentName;
  var _dob;
  late TextEditingController _email;
  late TextEditingController _gender;
  late TextEditingController _mobileNumber;
  late StudentModel _details;
  var _jadeedSuratName;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _arguments = ModalRoute.of(context)!.settings.arguments as Map;
      authProvider = Provider.of<Auth>(context, listen: false);
      _details = authProvider.students
          .firstWhere((element) => element.id == _arguments['id']);
      _studentName = TextEditingController(text: _details.name);
      _dob = TextEditingController(text: _details.dateOfBirth.toString());
      _email = TextEditingController(text: _details.email);
      _gender =
          TextEditingController(text: _details.gender ? 'Male' : 'Female');
      _mobileNumber = TextEditingController(text: _details.mobileNumber);
      _jadeedSuratName = quranData['references']!.firstWhere((element) =>
          element['number'] == _details.currentJadeedSurat)['englishName'];
    }
    print(_details.mobileNumber);
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void toggleAndSave() {
    setState(() {
      _isEdit = !_isEdit;
    });

    if (_isEdit) {
    } else {
      setState(() {
        _loading = true;
      });
      Provider.of<StudentProvider>(context, listen: false)
          .editStudentDetails(_details, context)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    final _studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    print(_jadeedSuratName);
    final Map<String, double> dataMapJuzhali = {
      "Passed": _details.avgJuzhali,
      "Failed": double.parse((100 - _details.avgJuzhali).toString()),
    };
    final Map<String, double> dataMapMurajah = {
      "Passed": _details.avgMurajah,
      "Failed": double.parse((100 - _details.avgMurajah).toString()),
    };
    final Map<String, double> dataMapAttendace = {
      "Passed": _details.avgAttendance,
      "Failed": double.parse((100 - _details.avgAttendance).toString()),
    };
    // print(_details.avgMurajah);
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DummyProfilePic(
                          (width * 0.35).toInt(), (width * 0.15).toInt()),
                    ),
                    // DummyProfilePic(150, 70),
                    Container(
                      width: 130,
                      child: TextField(
                        controller: _studentName,
                        enabled: _isEdit,
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          _details.name = val;
                        },
                      ),
                    ),
                    Text(
                      'Sana : ${_details.currentSana.toString()}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  height: 190,
                  margin: EdgeInsets.only(left: 25, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth : ${_details.dateOfBirth.day} / ${_details.dateOfBirth.month} / ${_details.dateOfBirth.year}',
                      ),
                      Row(
                        children: [
                          Text('Email :'),
                          Container(
                            width: width * 0.7,
                            margin: const EdgeInsets.only(left: 10),
                            child: TextField(
                              style: TextStyle(fontSize: height * 0.018),
                              enabled: _isEdit,
                              controller: _email,
                              onSubmitted: (val) {
                                _details.email = val;
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('Mobile Number :'),
                          Container(
                            width: width * 0.2,
                            margin: const EdgeInsets.only(left: 10),
                            child: TextField(
                              style: TextStyle(fontSize: height * 0.018),
                              enabled: _isEdit,
                              controller: _mobileNumber,
                              onSubmitted: (val) {
                                _details.mobileNumber = val;
                              },
                            ),
                          )
                        ],
                      ),
                      !_isEdit
                          ? Text(
                              'Gender : ${_details.gender ? 'Male' : 'Female'}')
                          : Row(children: [
                              Text('Gender'),
                              Switch(
                                  value: _details.gender,
                                  onChanged: (val) {
                                    setState(() {
                                      _details.gender = val;
                                    });
                                  })
                            ]),
                      Text('Current Jadeed Surat : $_jadeedSuratName'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Averages',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: (width * 0.06),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomChart(dataMapJuzhali, 'Average Juz Hali'),
                      CustomChart(dataMapMurajah, 'Average Murajah'),
                    ],
                  ),
                ),
                CustomChart(dataMapAttendace, 'Average Attendance'),
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSizeButton(
                        performingAction: () {
                          FlutterClipboard.copy(
                                  'https://tehfeez.herokuapp.com/api/get-more-records/?days=60&id=${_arguments['id']}&isPdf=True')
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Link copied to Clipboard'),
                              ),
                            );
                            launch('https://wa.me/91${_details.mobileNumber}');
                          });
                        },
                        icon: Text(
                          'Submit Report',
                          style: TextStyle(fontSize: 10),
                        ),
                        height: 40,
                        width: 120,
                        color: Colors.teal,
                      ),
                      CustomSizeButton(
                        performingAction: () {
                          Navigator.of(context).pushNamed(
                              StudentReportScreen.routeName,
                              arguments: _arguments['id']);
                        },
                        icon: Text(
                          'View Full report',
                          style: TextStyle(fontSize: 10),
                        ),
                        height: 40,
                        width: 120,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).errorColor)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Are you sure ?'),
                                content: Text(
                                    'All data of ${_details.name} will be erased forever...'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _studentProvider.deleteStudent(
                                            _details.id, context);
                                      },
                                      child: Text('Yes')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No')),
                                ],
                              ));
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete Student'),
                  ),
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Edit Student Details',
          onPressed: toggleAndSave,
          child: _loading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : _isEdit
                  ? Icon(Icons.save)
                  : Icon(Icons.edit),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }
}
