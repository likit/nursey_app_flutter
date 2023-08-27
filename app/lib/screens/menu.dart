import 'package:flutter/material.dart';
import 'package:bonfire_test/constants.dart';
import 'package:bonfire_test/widgets/themedContainer.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ThemedContainer(
              height: 70,
              child: Text(
                'Main Menu',
                style: kAppTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'เริ่มทดสอบ',
                      style: kAppTextStyle,
                    )),
                onPressed: () => {Navigator.pushNamed(context, '/lessons')},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ทบทวน', style: kAppTextStyle)),
                onPressed: () =>
                    {Navigator.pushNamed(context, '/scenarios_review')},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
