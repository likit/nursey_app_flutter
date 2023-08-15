import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class LessonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'บทเรียน',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: LessonList(),
              ),
            ),
            RaisedButton(
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Back',
                  style: kAppTextStyle,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/menu',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LessonList extends StatefulWidget {
  @override
  _LessonListState createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Widget> lessons;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('lessons').snapshots(),
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
                  Navigator.pushNamed(context, '/scenarios');
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.book),
                    trailing: (doc.data() as Map)['isPracticeMode'] == 'no'
                        ? Icon(Icons.lock_clock)
                        : null,
                    title: Text(
                      (doc.data() as Map)['name'],
                      style: kAppTextStyle,
                    ),
                    subtitle: Text(
                      (doc.data() as Map)['objective'],
                      style: kAppSubTextStyle,
                    ),
                    isThreeLine: true,
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
