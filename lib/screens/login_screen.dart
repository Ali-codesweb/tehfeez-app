import "package:flutter/material.dart";
import 'package:tehfeez/widgets/attribute.dart';
import '../providers/auth.dart';
import "package:provider/provider.dart";
import '../screens/add_entry_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../widgets/custom_size_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  var _isLoading = false;

  Map<String, String> _authData = {'username': '', 'password': ''};

  void _saveForm() async {
    print('save form initiated');
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    await Provider.of<Auth>(context, listen: false)
        .login(_authData['username'], _authData['password'], context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    print(height);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'lib/assets/banner.jpg',
              fit: BoxFit.none,
              alignment: Alignment.topCenter,
              height: height * 0.51,
              scale: 1.1,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                color: Colors.white,
              ),
              height: height * 0.6,
              padding: EdgeInsets.fromLTRB(70, 10, 70, 0),

              // mainAxisAlignment: MainAxisAlignment.center,
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      style: TextStyle(fontSize: height * 0.02),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Username cannot be null';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _authData['username'] = val!;
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.send,
                      style: TextStyle(fontSize: height * 0.02),
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Password cannot be null';
                        }
                      },
                      onSaved: (val) {
                        _authData['password'] = val!;
                      },
                      onFieldSubmitted: (val) {
                        _saveForm();
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 25),
                        child: Text(
                          'Forgot Password ?',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: height * 0.015),
                        ),
                      ),
                    ),
                    CustomSizeButton(
                      performingAction: () {
                        _saveForm();
                      },
                      icon: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text('Login'),
                      height: 40,
                      width: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: CustomSizeButton(
                        performingAction: () {
                          // _saveForm();
                          Navigator.of(context)
                              .pushNamed(AddEntryScreen.routeName);
                        },
                        icon: Text('Login as Guest'),
                        height: 40,
                        width: 80,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                key: _form,
              ),
            ),
          ),
          Attribute()
        ],
      ),
    );
  }
}
