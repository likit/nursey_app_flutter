import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';

class SessionArguments {
  final String sessionId;

  SessionArguments(this.sessionId);
}

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

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
                'Main Menu',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'เริ่ม session ใหม่',
                      style: kAppTextStyle,
                    )),
                onPressed: () {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  firestore.collection('sessions').add({
                    'email': auth.currentUser.email,
                    'created_at': Timestamp.now()
                  }).then((value) {
                    print('New session has been created. ${value.id}');
                    Navigator.pushNamed(context, '/lessons',
                        arguments: SessionArguments(value.id));
                  }).catchError((value) => {print('Error happened')});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ประวัติการเล่น', style: kAppTextStyle)),
                onPressed: () => {Navigator.pushNamed(context, '/history')},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ทบทวน', style: kAppTextStyle)),
                onPressed: () =>
                    {Navigator.pushNamed(context, '/scenarios_review')},
              ),
            ),
            Text(
              'คู่มือการใช้งาน',
              style: kAppTextStyle,
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    '1) ท่านสามารถเลือกสร้าง session ใหม่หรือเล่นต่อจาก session เดิมได้ในหน้าประวัติ' +
                        '\n\n2) โปรแกรมจะบันทึกคะแนนเมื่อท่านเข้าดูคะแนนและกดปุ่มบันทึกคะแนน' +
                        '\n\n3) ท่านสามารถทบทวนอุปกรณ์ต่าง ๆ ได้ในเมนูทบทวน' +
                        '\n\n4) ท่านสามารถดูแผนที่เพื่อศึกษาได้ก่อนเล่นจริง' +
                        '',
                    style: kAppTextStyle,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
