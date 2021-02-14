import 'package:flutter/material.dart';
import 'constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: kAppTitleTextStyle,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.0,
            ),
            LoginForm(),
            Text('กรุณาลงชื่อเข้าใช้งานหรือลงทะเบียนเพื่อใช้งาน', style: kAppTextStyle,)
          ],
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print('Logged in.');
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

