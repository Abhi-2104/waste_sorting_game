import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'level_screen.dart';

class LevelRoadmapScreen extends StatefulWidget {
  @override
  _LevelRoadmapScreenState createState() => _LevelRoadmapScreenState();
}

class _LevelRoadmapScreenState extends State<LevelRoadmapScreen> {
  int lastLevel = 1;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  void loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastLevel = prefs.getInt('lastLevel') ?? 1;
    });
  }

  void saveProgress(int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastLevel', level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level Roadmap'),
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
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: 17,
          itemBuilder: (context, index) {
            int level = index + 1;
            return GestureDetector(
              onTap: level <= lastLevel
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LevelScreen(
                            level: level,
                            saveProgress: saveProgress,
                          ),
                        ),
                      );
                    }
                  : null,
              child: CircleAvatar(
                backgroundColor: level <= lastLevel
                    ? Colors.green.shade600
                    : Colors.grey.shade400,
                child: Text(
                  '$level',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                radius: 25,
              ),
            );
          },
        ),
      ),
    );
  }
}
