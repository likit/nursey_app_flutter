import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets/themedContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'Login',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RegisterForm(
                signInMethod: logIn,
              ),
            ),
            Text(
              'ลงทะเบียนเพื่อใช้งานโดยใช้อีเมลของสถาบัน',
              style: kAppTextStyle,
            )
          ],
        ),
      ),
    );
  }

  void logIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "donsanova@gmail.com",
        password: "genius01",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}

class RegisterForm extends StatefulWidget {
  final Function signInMethod;

  const RegisterForm({Key key, this.signInMethod}) : super(key: key);
  @override
  _RegisterFormState createState() =>
      _RegisterFormState(signInMethod: signInMethod);
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final Function signInMethod;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _RegisterFormState({this.signInMethod});

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
              ),
              controller: _confirmPasswordController,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Re-enter your password';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.pinkAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Register',
                      style: kAppTextStyle,
                    ),
                  ),
                  onPressed: () async {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      if (_formKey.currentState.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          _showAlertDialog();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            _showFailedLoginDialog(e.code);
                          } else {
                            _showFailedLoginDialog(e.code);
                          }
                        }
                      } else {
                        print('Invalid email address.');
                      }
                    } else {
                      _showFailedLoginDialog('Passwords do not match.');
                      print(
                          '${_passwordController.text}, ${_confirmPasswordController.text}');
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  color: Colors.lightBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: kAppTextStyle,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Registration Status',
              style: kAppTextStyle,
            ),
            content: Container(
              child: Text(
                'ลงทะเบียนเข้าใช้งานเรียบร้อย',
                style: kAppTextStyle,
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Ok',
                      style: kAppTextStyle,
                    ),
                  ))
            ],
          );
        });
  }

  void _showFailedLoginDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Registration Status',
              style: kAppTextStyle,
            ),
            content: Container(
              child: Text(
                msg,
                style: kAppTextStyle,
              ),
            ),
            actions: [
              RaisedButton(
                color: Colors.grey,
                onPressed: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Try Again',
                    style: kAppTextStyle,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
