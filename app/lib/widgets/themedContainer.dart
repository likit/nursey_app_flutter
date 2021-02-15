import 'package:flutter/material.dart';

class ThemedContainer extends StatelessWidget {
  final double height;
  final Widget child;
  ThemedContainer({this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: height,
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
        ],
      ),
    );
  }
}
