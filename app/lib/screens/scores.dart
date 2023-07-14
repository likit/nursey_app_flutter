import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/models/timer.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  int score = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
              });
            } else {
              setState(() {
                score -= 1;
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
    var cart = context.watch<CartModel>();
    int seconds = Provider.of<TimerModel>(context, listen: false).seconds;
    int usedTime = (args.numItems * 15) - seconds;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () =>
                      Navigator.pushNamed(context, '/answers', arguments: args),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ดูเฉลย',
                      style: kAppTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  color: Colors.pinkAccent,
                  onPressed: () {
                    cart.clear();
                    return Navigator.pushNamed(context, '/scenarios');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ออก',
                      style: kAppTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
