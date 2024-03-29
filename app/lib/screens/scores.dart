import 'dart:convert';

import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/models/scenarios.dart';
import 'package:bonfire_test/models/timer.dart';
import 'package:bonfire_test/screens/menu.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  int score = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> correctItems = [];
  List<String> wrongItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      ScenarioArguments args = ModalRoute.of(context).settings.arguments;
      List<String> items = Provider.of<CartModel>(context, listen: false).items;
      firestore
          .collection('scenarios')
          .doc(args.id)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          items.forEach((var itemId) {
            if ((snapshot.data() as Map)['answers'].contains(itemId)) {
              setState(() {
                score += 1;
                correctItems.add(itemId);
              });
            } else {
              setState(() {
                score -= 1;
                wrongItems.add(itemId);
              });
            }
          });
        }
      });
    });
  }

  void _showAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Save Status',
              style: kAppTextStyle,
            ),
            content: Container(
              child: Text(
                message,
                style: kAppTextStyle,
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

  @override
  Widget build(BuildContext context) {
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
    var cart = context.watch<CartModel>();
    int seconds = Provider.of<TimerModel>(context, listen: false).seconds;
    // int usedTime = (args.numItems * 15) - seconds;
    int usedTime = seconds;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    var scenarioQueue = context.watch<ScenarioQueueModel>();
    var nextIndex = scenarioQueue.items.indexOf(args.id) + 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'คะแนน ${score}',
                style: kAppTitleTextStyle,
              ),
            ),
            Center(
              child: Text(
                'ใช้เวลาไป ${usedTime} วินาที',
                style: kAppTextStyle,
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore.collection('scenarios').doc(args.id).snapshots(),
                builder: (context, scenarioSnapshot) {
                  if (!scenarioSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: firestore
                                .collection('images')
                                .doc(cart.items[index])
                                .snapshots(),
                            builder: (context, itemSnapshot) {
                              if (itemSnapshot.hasData) {
                                return FutureBuilder(
                                  future: storage
                                      .ref(itemSnapshot.data['fileUrl'])
                                      .getDownloadURL(),
                                  builder: (context, downloadUrl) {
                                    if (downloadUrl.hasData) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.network(
                                              downloadUrl.data,
                                              width: 180,
                                              height: 120,
                                            ),
                                            Text(
                                              itemSnapshot.data['name'],
                                              style: kAppTextStyle,
                                            ),
                                            scenarioSnapshot.data['answers']
                                                    .contains(
                                                        itemSnapshot.data.id)
                                                ? Icon(
                                                    Icons.verified,
                                                    color:
                                                        Colors.yellow.shade600,
                                                    size: 60,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .sentiment_dissatisfied_outlined,
                                                    color: Colors.grey,
                                                    size: 60,
                                                  ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.brown.shade50,
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          border: Border.all(
                                              color: Colors.brown, width: 4),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              } else {
                                return Text('Error.');
                              }
                            });
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () => Navigator.pushNamed(context, '/answers',
                        arguments: args),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ดูเฉลย',
                        style: kAppTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      cart.clear();
                      firestore
                          .collection('plays')
                          .add({
                            'sessionId': args.sessionId,
                            'scores': score,
                            'correct': correctItems,
                            'wrong': wrongItems,
                            'savedAt': Timestamp.now(),
                            'time': usedTime,
                            'scenarioId': args.id,
                            'scenarioTitle': args.title,
                          })
                          .then((value) =>
                              {_showAlertDialog('บันทึกคะแนนเรียบร้อย')})
                          .catchError(
                              (value) => {_showAlertDialog('เกิดความผิดพลาด')});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'บันทึก',
                        style: kAppTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  color: Colors.pinkAccent,
                  onPressed: () {
                    cart.clear();
                    return Navigator.pushNamed(context, '/scenarios',
                        arguments: SessionArguments(args.sessionId));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ออก',
                      style: kAppTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    cart.clear();
                    firestore
                        .collection('scenarios')
                        .doc(scenarioQueue.items[nextIndex])
                        .get()
                        .then((DocumentSnapshot snapshot) {
                      if (snapshot.exists) {
                        return Navigator.pushNamed(
                          context,
                          '/get-ready',
                          arguments: ScenarioArguments(
                              snapshot.id,
                              (snapshot.data() as Map)['title'],
                              (snapshot.data() as Map)['answers'].length,
                              args.sessionId),
                        );
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ต่อไป',
                      style: kAppTextStyle,
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
