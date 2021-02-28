import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bonfire_test/models/cart.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../constants.dart';

class SelectedItems extends StatefulWidget {
  @override
  _SelectedItemsState createState() => _SelectedItemsState();
}

class _SelectedItemsState extends State<SelectedItems> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'รายการที่เลือก',
                style: kAppTextStyle,
              ),
            ),
            cart.items.length == 0
                ? Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'ไม่มีอุปกรณ์ที่เลือกในตะกร้า',
                      style: kAppTextStyle,
                    )),
                  )
                : Expanded(
                    flex: 1,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: firestore
                                .collection('images')
                                .doc(cart.items[index])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return FutureBuilder(
                                  future: storage
                                      .ref(snapshot.data['fileUrl'])
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
                                                snapshot.data['name'],
                                                style: kAppTextStyle,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                cart.update(cart.items[index]);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.reply,
                                                    color: Colors.red,
                                                    size: 50,
                                                  ),
                                                ],
                                              ),
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
                                return Text('No image found.');
                              }
                            });
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      cart.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ทิ้งทั้งหมด',
                        style: kAppTextStyle,
                      ),
                    ),
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
