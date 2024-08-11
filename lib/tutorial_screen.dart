import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; 
import 'levels.dart';

class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Play'),
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Welcome to the Waste Sorting Game!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset('assets/animations/tutorial_intro.json', height: 200), // Example animation
            SizedBox(height: 20),
            Text(
              'Step 1: Drag and drop waste items into the correct bins. You will see different types of waste, and your task is to sort them accurately.',
              style: TextStyle(fontSize: 18, color: Colors.teal.shade800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset('assets/animations/drag_drop.json', height: 200), // Example animation
            SizedBox(height: 20),
            Text(
              'Step 2: Pay attention to the different types of bins and waste items. Each bin represents a different category of waste.',
              style: TextStyle(fontSize: 18, color: Colors.teal.shade800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset('assets/animations/bin_types.json', height: 200), // Example animation
            SizedBox(height: 20),
            Text(
              'Step 3: Complete each level to progress further. New items and bins will be introduced as you advance through the levels.',
              style: TextStyle(fontSize: 18, color: Colors.teal.shade800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset('assets/animations/level_complete.json', height: 200), // Example animation
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal.shade300,
              ),
              child: Text('Start Game'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelRoadmapScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
