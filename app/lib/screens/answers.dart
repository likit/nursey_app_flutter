import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AnswerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text('เฉลย', style: kAppTitleTextStyle,),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('scenarios')
                    .doc(args.id)
                    .snapshots(),
                builder: (context, scenarioSnapshot) {
                  if (!scenarioSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      shrinkWrap: true,
                      itemCount: scenarioSnapshot.data['answers'].length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: firestore
                                .collection('images')
                                .doc(scenarioSnapshot.data['answers'][index])
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
                                            cart.items.contains(
                                                itemSnapshot.data.id)
                                                ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 50,
                                            )
                                                : Icon(
                                              Icons
                                                  .check_circle_outline,
                                              color: Colors.grey,
                                              size: 50,
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
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'เล่นใหม่',
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
                  'กลับ',
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