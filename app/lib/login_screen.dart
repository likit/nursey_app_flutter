import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets/themedContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              child: LoginForm(
                signInMethod: logIn,
              ),
            ),
            Text(
              'กรุณาลงชื่อเข้าใช้งานหรือลงทะเบียนเพื่อใช้งาน',
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

class LoginForm extends StatefulWidget {
  final Function signInMethod;

  const LoginForm({Key key, this.signInMethod}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState(signInMethod: signInMethod);
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final Function signInMethod;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _LoginFormState({this.signInMethod});

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  return 'Enter your email';
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
                      'Log In',
                      style: kAppTextStyle,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        _showAlertDialog();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          _showFailedLoginDialog(e.code);
                        } else if (e.code == 'wrong-password') {
                          _showFailedLoginDialog(e.code);
                        } else {
                          _showFailedLoginDialog(e.code);
                        }
                      }
                    } else {
                      print('Invalid email address.');
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
                      'Register',
                      style: kAppTextStyle,
                    ),
                  ),
                  onPressed: () {},
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
              'Login Status',
              style: kAppTextStyle,
            ),
            content: Container(
              child: Text(
                'ลงชื่อเข้าใช้งานเรียบร้อย',
                style: kAppTextStyle,
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () => Navigator.pushNamed(context, '/lessons'),
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
              'Login Status',
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
