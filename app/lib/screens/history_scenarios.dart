import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu.dart';

class HistoryScenarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SessionArguments args = ModalRoute.of(context).settings.arguments;
    if (args?.sessionId == null) {
      Navigator.pushNamed(context, '/menu');
    }
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
              child: Text('Scenario ที่เล่นมาแล้ว', style: kAppTextStyle),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: HistoryScenarioList(),
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
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'เริ่มเล่น',
                        style: kAppTextStyle,
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/lessons',
                        arguments: SessionArguments(args.sessionId)),
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

class HistoryScenarioList extends StatefulWidget {
  @override
  _HistoryScenarioListState createState() => _HistoryScenarioListState();
}

class _HistoryScenarioListState extends State<HistoryScenarioList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Widget> lessons;

  @override
  Widget build(BuildContext context) {
    SessionArguments args = ModalRoute.of(context).settings.arguments;
    return StreamBuilder(
      stream: firestore
          .collection('plays')
          .where('sessionId', isEqualTo: args.sessionId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data.docs.map((doc) {
              var datetime = (doc.data() as Map)['savedAt'];
              var title = (doc.data() as Map)['scenarioTitle'];
              var scores = (doc.data() as Map)['scores'].toString();
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/lessons',
                    arguments: SessionArguments(doc.id),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('$title: ${datetime.toDate()} คะแนน=$scores',
                        style: kAppTextStyle),
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
