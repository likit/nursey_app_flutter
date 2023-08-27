import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire_test/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScenarioArguments {
  final String id;

  ScenarioArguments(this.id);
}

class ScenarioReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'สถานการณ์',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ScenarioList(),
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
                    width: 10,
                  ),
                  RaisedButton(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'แผนที่',
                        style: kAppTextStyle,
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/map'),
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

class ScenarioList extends StatefulWidget {
  @override
  _ScenarioListState createState() => _ScenarioListState();
}

class _ScenarioListState extends State<ScenarioList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Widget> lessons;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('scenarios').orderBy("number").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data.docs.map((doc) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/answers_review',
                      arguments: ScenarioArguments(doc.id));
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      (doc.data() as Map)['title'],
                      style: kAppTextStyle,
                    ),
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
