import 'dart:async';
import 'package:bonfire_test/models/timer.dart';
import 'package:bonfire_test/screens/menu.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetReadyScreen extends StatefulWidget {
  @override
  _GetReadyScreenState createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends State<GetReadyScreen> {
  int delay = 5;
  int totalSeconds = 0;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          delay--;
        });
        if (delay == 0) {
          timer.cancel();
          Navigator.pushNamed(context, '/playmap', arguments: args);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
    var timer = context.watch<TimerModel>();
    // timer.seconds = 15 * args.numItems;
    timer.seconds = 0;
    totalSeconds = timer.seconds;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                args.title,
                style: kAppScenarioTitleTextStyle,
              ),
            ),
            Center(
              child: Column(
                children: [
/*                   Text(
                    'เวลาทั้งหมด ${totalSeconds} วินาที',
                    style: kAppItemTextStyle,
                  ), */
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Getting ready..',
                    style: kAppItemTextStyle,
                  ),
                  Text(
                    '${delay}',
                    style: kAppCountdownTextStyle,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    color: Colors.pinkAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ยกเลิก',
                        style: kAppTextStyle,
                      ),
                    ),
                    onPressed: () {
                      _timer.cancel();
                      return Navigator.pushNamed(context, '/scenarios',
                          arguments: SessionArguments(args.sessionId));
                    }),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'เริ่มทันที',
                        style: kAppTextStyle,
                      ),
                    ),
                    onPressed: () {
                      _timer.cancel();
                      return Navigator.pushNamed(context, '/playmap',
                          arguments: args);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
