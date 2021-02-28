import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/models/cart.dart';
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
            if (snapshot.data()['answers'].contains(itemId)) {
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
    var cart = context.watch<CartModel>();
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;

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
                    scenarioSnapshot.data['answers'].forEach((var itemId) {
                      if (cart.items.contains(itemId)) {
                        score += 1;
                      }
                    });
                    return GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
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
                                        margin: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.network(
                                              downloadUrl.data,
                                              width: 180,
                                              height: 120,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                itemSnapshot.data['name'],
                                                style: kAppTextStyle,
                                              ),
                                            ),
                                            scenarioSnapshot.data['answers']
                                                    .contains(
                                                        itemSnapshot.data.id)
                                                ? Icon(
                                                    Icons.verified,
                                                    color: Colors.yellow.shade600,
                                                    size: 60,
                                                  )
                                                : Icon(
                                                    Icons.sentiment_dissatisfied_outlined,
                                                    color: Colors.grey,
                                                    size: 40,
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
            RaisedButton(
              color: Colors.pinkAccent,
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ไปหน้ารายการ',
                  style: kAppTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
