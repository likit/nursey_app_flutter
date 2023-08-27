import 'package:bonfire_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/item_container.dart';
import 'package:flutter/gestures.dart';
import 'package:tuple/tuple.dart';

String containerId = '';
String containerName = '';

class ContainerArguments {
  final String containerId;
  final String containerName;
  ContainerArguments({this.containerId, this.containerName});
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        height: double.infinity,
        child: MainContent(),
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoomMap(),
            Row(
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
                  width: 10,
                ),
                RaisedButton(
                  color: Colors.pinkAccent,
                  onPressed: () {
                    if (containerId != '') {
                      return Navigator.pushNamed(
                        context,
                        '/container-item',
                        arguments: ContainerArguments(
                            containerId: containerId,
                            containerName: containerName),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ดูอุปกรณ์',
                      style: kAppTextStyle,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoomMap extends StatefulWidget {
  @override
  _RoomMapState createState() => _RoomMapState();
}

class _RoomMapState extends State<RoomMap> {
  String startDXPoint = '';
  String startDYPoint = '';
  String itemLabel = '';
  GlobalKey _keyMapImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 70,
                margin: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.brown.shade300,
                    border: Border.all(color: Colors.brown.shade700, width: 8),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 5.0,
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'แผนที่หอผู้ป่วย',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Itim',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
        GestureDetector(
          dragStartBehavior: DragStartBehavior.start,
          behavior: HitTestBehavior.translucent,
          onTapDown: (TapDownDetails details) {
            RenderBox imageBox = _keyMapImage.currentContext.findRenderObject();
            var local = imageBox.globalToLocal(details.globalPosition);
            setState(() {
              Tuple2 _container = checkItem(local);
              this.itemLabel = _container.item1;
              containerName = _container.item1;
              containerId = _container.item2;
              this.startDXPoint = '${local.dx.floorToDouble()}';
              this.startDYPoint = '${local.dy.floorToDouble()}';
            });
          },
          child: Container(
            key: _keyMapImage,
            color: Colors.yellow.shade100,
            child: Image.asset('assets/images/room4_labels.png'),
          ),
        ),
        Text(
          'Start DX point: ${this.startDXPoint}',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Start DY point: ${this.startDYPoint}',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            this.itemLabel != '' ? '${this.itemLabel}' : 'กรุณาคลิกที่อื่น',
            style: kAppItemTextStyle,
          ),
        ),
      ],
    );
  }

  Tuple2 checkItem(var localPosition) {
    double localx = localPosition.dx.floorToDouble();
    double localy = localPosition.dy.floorToDouble();
    String label = '';
    for (ItemContainer con in itemContainers) {
      if (localx.floorToDouble().clamp(con.x1, con.x2) == localx &&
          localy.floorToDouble().clamp(con.y1, con.y2) == localy) {
        return Tuple2<String, String>(con.label, con.id);
      }
    }
    return Tuple2<String, String>(label, '');
  }
}
