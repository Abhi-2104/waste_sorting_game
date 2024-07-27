import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('lastLevel', 1); // Reset progress on each build
  runApp(WasteSortingGame());
}

class WasteSortingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
