import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/item_container.dart';
import 'package:flutter/gestures.dart';

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
            RenderBox getBox = context.findRenderObject();
            var local = getBox.globalToLocal(details.globalPosition);
            setState(() {
              this.itemLabel = checkItem(local);
              this.startDXPoint = '${local.dx.floorToDouble()}';
              this.startDYPoint = '${local.dy.floorToDouble()}';
            });
          },
          child: Container(
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

  String checkItem(var localPosition) {
    double localx = localPosition.dx.floorToDouble();
    double localy = localPosition.dy.floorToDouble();
    String label = '';
    for (ItemContainer con in itemContainers) {
      if (localx.floorToDouble().clamp(con.x1, con.x2) == localx &&
          localy.floorToDouble().clamp(con.y1, con.y2) == localy) {
        return con.label;
      }
    }
    return label;
  }
}
