import 'package:bonfire_test/constants.dart';
import 'package:flutter/material.dart';
import 'map.dart' show ScenarioArguments;


class ContainerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScenarioArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(args.id),
              RaisedButton(
                onPressed: ()=>Navigator.pop(context),
                color: Colors.pinkAccent,
                child: Text('กลับ', style: kAppTextStyle,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
