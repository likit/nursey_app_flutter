import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'History',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('เลือก session ที่ต้องการเพื่อเล่นต่อ',
                  style: kAppTextStyle),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: HistorySessionList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.pinkAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ย้อนกลับ',
                        style: kAppTextStyle,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistorySessionList extends StatefulWidget {
  @override
  _HistorySessionListState createState() => _HistorySessionListState();
}

class _HistorySessionListState extends State<HistorySessionList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Widget> lessons;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('sessions')
          .orderBy("created_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data.docs.map((doc) {
              var datetime = (doc.data() as Map)['created_at'];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/history_scenarios',
                    arguments: SessionArguments(doc.id),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('${datetime.toDate()}', style: kAppTextStyle),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
