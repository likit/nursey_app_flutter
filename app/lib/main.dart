import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/models/timer.dart';
import 'package:bonfire_test/screens/answers.dart';
import 'package:bonfire_test/screens/container_items.dart';
import 'package:bonfire_test/screens/getting_ready.dart';
import 'package:bonfire_test/screens/item_list.dart';
import 'package:bonfire_test/screens/map.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/screens/lesson_list.dart';
import 'package:bonfire_test/screens/scores.dart';
import 'package:bonfire_test/screens/select_items.dart';
import 'package:provider/provider.dart';
import 'screens/play_map.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimerModel(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/lessons': (context) => LessonScreen(),
        '/scenarios': (context) => ScenarioScreen(),
        '/map': (context) => MapScreen(),
        '/playmap': (context) => PlayMapScreen(),
        '/container-item': (context) => ContainerItem(),
        '/item-list': (context) => ItemList(),
        '/select-items': (context) => SelectedItems(),
        '/scores': (context) => ScoreScreen(),
        '/answers': (context) => AnswerScreen(),
        '/get-ready': (context) => GetReadyScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
