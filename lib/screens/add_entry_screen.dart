import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tehfeez/screens/ikhtebaar_screen.dart';
import '../widgets/attribute.dart';
import '../widgets/preview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/jadeed.dart';
import '../components/juzhaliComp.dart';
import '../components/murajahComp.dart';
import '../providers/auth.dart';
import '../providers/entry.dart';
import '../widgets/custom_size_button.dart';

class AddEntryScreen extends StatefulWidget {
  static const routeName = '/add-entry';

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  var _isGuest = false;

  @override
  void initState() {
    Provider.of<Entry>(context, listen: false).generateJuzHaliList();
    if (Provider.of<Entry>(context, listen: false).token == null ||
        Provider.of<Entry>(context, listen: false).token == '') {
      _isGuest = true;
    }
    super.initState();
  }

  int _stuId = 1;
  TextEditingController juzHaliFromController =
      TextEditingController(text: '0');
  TextEditingController juzHaliToController = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    print('enrty screen built');
    final entryProvider = Provider.of<Entry>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Are you sure you want to leave ?'),
                  content: Text('Your data will be lost'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No')),
                    ElevatedButton(
                        onPressed: () {
                          
                          Navigator.of(context).pop();
                          willLeave = true;
                        },
                        child: Text('Yes')),
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 23),
                  child: Text(
                    'New Entry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: width * 0.07,
                    ),
                  ),
                ),
                !_isGuest
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Name : ',
                              style: TextStyle(fontSize: width * 0.038),
                            ),
                            authProvider.students.length > 0
                                ? DropdownButton(
                                    menuMaxHeight: 350,
                                    hint: Text(
                                      'Student Name',
                                      style: TextStyle(fontSize: width * 0.038),
                                    ),
                                    items: authProvider.students.map((e) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                              fontSize: width * 0.038),
                                        ),
                                        value: e.id,
                                      );
                                    }).toList()
                                      ..add(DropdownMenuItem(
                                        child: Text(
                                          'Anonymous',
                                          style: TextStyle(
                                              fontSize: width * 0.038),
                                        ),
                                        value: 0,
                                      )),
                                    onChanged: (val) {
                                      if (val == 0) {
                                        setState(() {
                                          entryProvider.entry.studentId =
                                              val as int;
                                          entryProvider.entry.studentName =
                                              'Anonymous';
                                          entryProvider.entry.jadeedSurat = 1;
                                          // entryProvider.entry.jadeedAyat = 11;
                                        });
                                      } else {
                                        setState(() {
                                          _stuId = val as int;
                                          final _stu = authProvider.students
                                              .firstWhere((element) =>
                                                  element.id == val);
                                          entryProvider.entry.studentName =
                                              _stu.name;
                                          entryProvider.entry.studentId =
                                              _stu.id;
                                          entryProvider.entry.jadeedSurat =
                                              _stu.currentJadeedSurat;
                                          entryProvider.entry.jadeedAyat =
                                              _stu.currentJadeedSuratAyat;
                                        });
                                      }
                                    },
                                    value: entryProvider.entry.studentId,
                                  )
                                : Row(
                                    children: [
                                      // Text(
                                      //   'Name : ',
                                      // ),
                                      Container(
                                        width: 100,
                                        child: TextField(
                                          onChanged: (val) {
                                            if (val == '')
                                              return;
                                            entryProvider.entry.studentName =
                                                val;
                                            print(entryProvider
                                                .entry.studentName);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            'Name : ',
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              onChanged: (val) {
                                if (val == '') return;
                                entryProvider.entry.studentName = val;
                                print(entryProvider.entry.studentName);
                              },
                            ),
                          )
                        ],
                      ),
                MurajahComp(),
                JuzHaliComp(),
                Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: Jadeed(_stuId)),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Preview(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.05),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSizeButton(
                        performingAction: () {
                          FlutterClipboard.copy(entryProvider.getStringToCopy())
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied to Clipboard'),
                              ),
                            );
                          });
                        },
                        icon: Text(
                          'Copy ',
                          style: TextStyle(fontSize: width * 0.035),
                        ),
                        height: 28,
                        width: width * 0.3,
                        color: Colors.teal,
                      ),
                      authProvider.students.length > 0 &&
                              entryProvider.entry.studentId != 0
                          ? CustomSizeButton(
                              performingAction: () {
                                final _stu = authProvider.students.firstWhere(
                                    (element) =>
                                        element.id ==
                                        entryProvider.entry.studentId);
                                entryProvider.addEntry(context).then((_) {
                                  FlutterClipboard.copy(
                                    entryProvider.getStringToCopy(),
                                  ).then((_) {

                                    launch(
                                        'https://wa.me/91${_stu.mobileNumber}');
                                  });
                                });
                              },
                              icon: Text(
                                authProvider.students.length > 0
                                    ? 'Upload and share'
                                    : 'Select a student',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: width * 0.035),
                              ),
                              height: 28,
                              width: width * 0.39,
                              color: Colors.teal,
                              enabled: authProvider.students.length > 0
                                  ? true
                                  : false,
                            )
                          : Container(
                              width: width * 0.5,
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: width * 0.035),
                              ),
                            ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 23,bottom:23),
                //   child: CustomSizeButton(
                //     performingAction: () {
                //       Navigator.of(context)
                //           .pushNamed(IkhtebaarScreen.routeName);
                //     },
                //     icon: Text('Ikhtebaar', style: TextStyle(fontSize: 18)),
                //     height: 30,
                //     width: width * 0.3,
                //     color: Theme.of(context).primaryColor,
                //   ),
                // ),
                Attribute()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
