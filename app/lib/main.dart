import 'package:bonfire_test/models/cart.dart';
import 'package:bonfire_test/models/scenarios.dart';
import 'package:bonfire_test/models/timer.dart';
import 'package:bonfire_test/register_screen.dart';
import 'package:bonfire_test/screens/answers.dart';
import 'package:bonfire_test/screens/answers_review.dart';
import 'package:bonfire_test/screens/container_items.dart';
import 'package:bonfire_test/screens/getting_ready.dart';
import 'package:bonfire_test/screens/item_list.dart';
import 'package:bonfire_test/screens/map.dart';
import 'package:bonfire_test/screens/menu.dart';
import 'package:bonfire_test/screens/scenario_list.dart';
import 'package:bonfire_test/screens/lesson_list.dart';
import 'package:bonfire_test/screens/scores.dart';
import 'package:bonfire_test/screens/select_items.dart';
import 'package:provider/provider.dart';
import 'models/session.dart';
import 'screens/play_map.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_test/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bonfire_test/screens/scenario_review_list.dart';

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
        ),
        ChangeNotifierProvider(
          create: (context) => ScenarioQueueModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionModel(),
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
        '/register': (context) => RegisterScreen(),
        '/menu': (context) => MenuScreen(),
        '/lessons': (context) => LessonScreen(),
        '/scenarios': (context) => ScenarioScreen(),
        '/scenarios_review': (context) => ScenarioReviewScreen(),
        '/map': (context) => MapScreen(),
        '/playmap': (context) => PlayMapScreen(),
        '/container-item': (context) => ContainerItem(),
        '/item-list': (context) => ItemList(),
        '/select-items': (context) => SelectedItems(),
        '/scores': (context) => ScoreScreen(),
        '/answers': (context) => AnswerScreen(),
        '/answers_review': (context) => AnswerReviewScreen(),
        '/get-ready': (context) => GetReadyScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
