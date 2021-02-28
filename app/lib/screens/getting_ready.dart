import 'dart:async';
import 'package:bonfire_test/widgets/themedContainer.dart';
import 'package:quiver/async.dart';
import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:flutter/material.dart';

class GetReadyScreen extends StatefulWidget {
  @override
  _GetReadyScreenState createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends State<GetReadyScreen> {
  int delay = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final ScenarioArguments args = ModalRoute.of(context).settings.arguments;
      Timer.periodic(Duration(seconds: 1), (timer) {
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
            RaisedButton(
              color: Colors.pinkAccent,
              child: Text(
                'ยกเลิก',
                style: kAppTextStyle,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
