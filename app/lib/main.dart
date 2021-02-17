import 'package:bonfire_test/screens/container_items.dart';
import 'package:bonfire_test/screens/map.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/screens/lesson_list.dart';
import 'screens/play_map.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context)=>LoginScreen(),
        '/lessons': (context)=>LessonScreen(),
        '/scenarios': (context)=>ScenarioScreen(),
        '/map': (context)=>MapScreen(),
        '/playmap': (context)=>PlayMapScreen(),
        '/container-item': (context)=>ContainerItem(),
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}

