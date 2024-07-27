import 'package:flutter/material.dart';
import 'levels.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Sorting Game'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.teal.shade300,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text('Start Game'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LevelRoadmapScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
