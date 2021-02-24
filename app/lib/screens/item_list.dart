import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/screens/play_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

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
  String containerName;

  @override
  Widget build(BuildContext context) {
    final ListItemArguments args = ModalRoute.of(context).settings.arguments;
    containerId = args.containerId;
    sceneId = args.sceneId;
    containerName = args.containerName;
    var cart = context.watch<CartModel>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                '${containerName}',
                style: kAppTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('จำนวนอุปกรณ์ที่เลือก: ${cart.items.length.toString()}', style: kAppTextStyle,),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('holders')
                    .doc(containerId)
                    .snapshots(),
                builder: (context, containerSnapshot) {
                  if (!containerSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      shrinkWrap: true,
                      itemCount: containerSnapshot.data['images'].length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: firestore
                                .collection('images')
                                .doc(containerSnapshot.data['images'][index])
                                .snapshots(),
                            builder: (context, itemSnapshot) {
                              if (itemSnapshot.hasData) {
                                print('---${itemSnapshot.data['fileUrl']}');
                                return FutureBuilder(
                                  future: storage.ref(itemSnapshot.data['fileUrl']).getDownloadURL(),
                                  builder: (context, downloadUrl) {
                                    if (downloadUrl.hasData) {
                                      return GestureDetector(
                                        onTap: () {
                                          print('selected ${itemSnapshot.data['fileUrl']} ${cart.items.length}');
                                          cart.update(itemSnapshot.data['fileUrl']);
                                        },
                                        child: Container(
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
                                              cart.items.contains(itemSnapshot.data['fileUrl'])
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 40,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.brown.shade50,
                                            borderRadius: BorderRadius.circular(18.0),
                                            border: Border.all(
                                                color: Colors.brown,
                                                width: 4),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'Loading..',
                                          style: kAppTextStyle,
                                        ),
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
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
