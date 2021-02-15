import 'package:flutter/material.dart';
import 'widgets/themedContainer.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ThemedContainer(
                height: 70,
                child: Text('Login', style: kAppTitleTextStyle,),
              ),
              SizedBox(
                height: 30.0,
              ),
              LoginForm(
                signInMethod: logIn,
              ),
              Text(
                'กรุณาลงชื่อเข้าใช้งานหรือลงทะเบียนเพื่อใช้งาน',
                style: kAppTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  void logIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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

  _LoginFormState({this.signInMethod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
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
                FlatButton(
                  color: Colors.pinkAccent,
                  child: Text(
                    'Log In',
                    style: kAppTextStyle,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print('Valid email');
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: "donsanova@gmail.com",
                          password: "genius01",
                        );
                        print('You have just logged in');
                        print(userCredential.user);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        } else {
                          print(e.code);
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
                FlatButton(
                  color: Colors.yellow,
                  child: Text(
                    'Register',
                    style: kAppTextStyle,
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
}
