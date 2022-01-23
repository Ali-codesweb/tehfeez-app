import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/screens/student_entry_report_screen.dart';
import './providers/auth.dart';
import './providers/entry.dart';
import './providers/student.dart';
import './screens/add_entry_screen.dart';
import './screens/add_student_screen.dart';
import './screens/forgot_password_screen.dart';
import './screens/student_detail_screen.dart';
import './screens/student_report_screen.dart';
import './screens/teacher_profile_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/ikhtebaar_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Entry>(
          create: (_) => Entry(),
          update: (ctx, auth, previousEntry) => previousEntry!
            ..update(
              (auth.students.length > 0 ? auth.students.first.name : ''),
              (auth.students.length > 0 ? auth.students.first.id : 1),
              (auth.students.length > 0
                  ? auth.students.first.currentJadeedSurat
                  : 1),
              (auth.teacher.token != '')
                  ? auth.teacher.token
                  : '',
            ),
        ),
        ChangeNotifierProxyProvider<Auth, StudentProvider>(
            
            create: (_)=>StudentProvider(),
            update: (ctx, auth, previousStudProv) =>
                previousStudProv!..update(auth.teacher.token))
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tehfeez',
          theme: ThemeData(

            primarySwatch: MaterialColor(0xFF7F1801, {
              50: Color.fromRGBO(127, 24, 1, .1),
              100: Color.fromRGBO(127, 24, 1, .2),
              200: Color.fromRGBO(127, 24, 1, .3),
              300: Color.fromRGBO(127, 24, 1, .4),
              400: Color.fromRGBO(127, 24, 1, .5),
              500: Color.fromRGBO(127, 24, 1, .6),
              600: Color.fromRGBO(127, 24, 1, .7),
              700: Color.fromRGBO(127, 24, 1, .8),
              800: Color.fromRGBO(127, 24, 1, .9),
              900: Color.fromRGBO(127, 24, 1, 1),
            }),
            fontFamily: 'Poppins',
            textTheme: TextTheme(
            )
          ),
          home: HomeScreen(),
          routes: {
            AddEntryScreen.routeName: (_) => AddEntryScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            ForgotPasswordScreen.routeName: (_) => ForgotPasswordScreen(),
            StudentDetailScreen.routeName: (_) => StudentDetailScreen(),
            TeacherProfileScreen.routeName: (_) => TeacherProfileScreen(),
            AddStudentScreen.routeName: (_) => AddStudentScreen(),
            StudentReportScreen.routeName: (_) => StudentReportScreen(),
            IkhtebaarScreen.routeName: (_) => IkhtebaarScreen(),
            StudentEntryReportScreen.routeName: (_) => StudentEntryReportScreen(),
          },
        ),
      ),
    );
  }
}
