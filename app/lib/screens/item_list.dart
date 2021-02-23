import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/screens/play_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  List<Widget> items;
  String containerId;
  String sceneId;

  @override
  Widget build(BuildContext context) {
    final ListItemArguments args = ModalRoute.of(context).settings.arguments;
    containerId = args.containerId;
    sceneId = args.sceneId;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                '${sceneId}',
                style: kAppTextStyle,
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore.collection('holders').doc(containerId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      shrinkWrap: true,
                      itemCount: snapshot.data['images'].length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: firestore
                                .collection('images')
                                .doc(snapshot.data['images'][index])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return FutureBuilder(
                                  future: storage
                                      .ref(snapshot.data['fileUrl'])
                                      .getDownloadURL(),
                                  builder: (context, fileUrl) {
                                    if (snapshot.hasData) {
                                      if (fileUrl.data != null) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Image.network(fileUrl.data),
                                            alignment: Alignment.center,
                                          ),
                                        );
                                      } else {
                                        return Text('No fileUrl');
                                      }
                                    } else {
                                      return Text('No fileUrl');
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
