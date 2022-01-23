import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/widgets/attribute.dart';
import 'package:tehfeez/widgets/custom_size_button.dart';
import '../providers/auth.dart';
import './add_entry_screen.dart';
import '../screens/teacher_profile_screen.dart';
import '../widgets/dummy_profile_pic.dart';
import '../widgets/student.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_android_pip/flutter_android_pip.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _loading = false;
  String shortcut = 'no action set';
  var _sharedText = 'noo';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final authProvider = Provider.of<Auth>(context);

      setState(() {
        _loading = true;
      });
      authProvider.fetchStudents(context).then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'login_as_guest':
          Navigator.of(context).pushReplacementNamed(AddEntryScreen.routeName);
          break;
        case 'home_screen':
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'login_as_guest',
        localizedTitle: 'Login as Guest',
        icon: 'ic_launcher',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'home_screen',
        localizedTitle: 'Home Screen',
        icon: 'ic_launcher',
      ),
    ]).then((value) {
      setState(() {
        if (shortcut == 'no action set') {
          shortcut = 'actions ready';
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rendered again');
    final authProvider = Provider.of<Auth>(context);
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: height * 0.6,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: height * 0.42,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(TeacherProfileScreen.routeName);
                        },
                        child: DummyProfilePic(
                            (width * 0.32).toInt(), (width * 0.2).toInt()),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Column(
                          children: [
                            AutoSizeText(
                              authProvider.teacher.name != null
                                  ? authProvider.teacher.name
                                  : '',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: height * 0.02,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                              child: AutoSizeText(
                                'Muhaffiz',
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: width * 0.038),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 0.5,
                  height: height * 0.35,
                  child: Column(
                    children: [
                      Text(
                        'Track your Student\'s Performance here',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: height * 0.03,
                        ),
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                      CustomSizeButton(
                          performingAction: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.refresh),
                          height: 50,
                          width: 50,
                          color: Colors.amber)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: height * 0.6,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.1),
                  topRight: Radius.circular(width * 0.1),
                ),
              ),
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                          children: authProvider.students
                              .map((e) => Student(
                                  name: e.name,
                                  profilePicture: e.profilePicture,
                                  sana: e.currentSana,
                                  id: e.id))
                              .toList()),
                    )),
        ),
        Attribute(),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        Text(
          authProvider.students.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: authProvider.students.length.toString(),
        onPressed: () {
          Navigator.of(context).pushNamed(AddEntryScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
