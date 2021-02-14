import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'item_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GestureDetectorPage(),
    );
  }
}

class GestureDetectorPage extends StatelessWidget {
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
                    BoxShadow(spreadRadius: 5.0, color: Colors.grey.withOpacity(0.5), blurRadius: 7, offset: Offset(0, 3)),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    this.itemLabel,
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
      ],
    );
  }
  String checkItem(var localPosition) {
    double localx = localPosition.dx.floorToDouble();
    double localy = localPosition.dy.floorToDouble();
    String label = '';
    for (ItemContainer con in itemContainers) {
      if(localx.floorToDouble().clamp(con.x1, con.x2) == localx && localy.floorToDouble().clamp(con.y1, con.y2) == localy) {
        return con.label;
      }
    }
    return label;
  }
}
