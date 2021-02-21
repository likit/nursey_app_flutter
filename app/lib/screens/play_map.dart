import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/item_container.dart';
import 'package:flutter/gestures.dart';
import 'package:tuple/tuple.dart';

//TODO: remove duplicate code.

String sceneId = '';

class PlayMapScreen extends StatelessWidget {
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
            RaisedButton(
              color: Colors.pink,
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'สำเร็จ',
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
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
    return Column(
      children: [
        ThemedContainer(
          height: 70,
          child: Text(
            args.title,
            style: kAppScenarioTitleTextStyle,
          ),
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
              sceneId = _container.item2;
              print(sceneId);
              this.startDXPoint = '${local.dx.floorToDouble()}';
              this.startDYPoint = '${local.dy.floorToDouble()}';
            });
          },
          child: Container(
            key: _keyMapImage,
            color: Colors.yellow.shade100,
            child: Image.asset('assets/images/room4.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'จำนวนอุปกรณ์ทั้งหมดคือ ${args.numItems} ชิ้น',
            style: kAppTextStyle,
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
