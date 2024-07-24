import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(WasteSortingGame());
}

class WasteSortingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Sorting Game'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Game'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LevelRoadmapScreen()),
            );
          },
        ),
      ),
    );
  }
}

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
      ),
      body: ListView.builder(
        itemCount: 17, // Adjust based on the number of levels
        itemBuilder: (context, index) {
          int level = index + 1;
          return ListTile(
            title: Text('Level $level'),
            onTap: level <= lastLevel
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelScreen(level: level, saveProgress: saveProgress),
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}

class LevelScreen extends StatefulWidget {
  final int level;
  final Function(int) saveProgress;

  LevelScreen({required this.level, required this.saveProgress});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int score = 0;
  ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  final List<String> allWasteItems = [
    'apple', 'banana_peel', 'newspaper', 'bottle', 'magazine',
    'plastic_bag', 'battery', 'mask', 'syringe', 'light_bulb',
    // Add more items as needed, up to 50
  ];

  final Map<String, String> wasteItemBins = {
    'apple': 'green',
    'banana_peel': 'green',
    'newspaper': 'blue',
    'bottle': 'blue',
    'magazine': 'blue',
    'plastic_bag': 'blue',
    'battery': 'red',
    'mask': 'red',
    'syringe': 'red',
    'light_bulb': 'red',
    // Add more item-bin mappings as needed
  };

  List<String> wasteItems = [];
  List<String> correctBins = [];

  @override
  void initState() {
    super.initState();
    loadLevel();
  }

  void loadLevel() {
    wasteItems = allWasteItems.skip((widget.level - 1) * 3).take(3).toList();
    correctBins = wasteItems.map((item) => wasteItemBins[item]!).toList();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Sorting Game - Level ${widget.level}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Text('Score: $score'),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDragTarget('green'),
                    buildDragTarget('blue'),
                    buildDragTarget('red'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: wasteItems.map((item) => buildDraggable(item)).toList(),
                ),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.green, Colors.blue, Colors.red],
          ),
        ],
      ),
    );
  }

  Widget buildDraggable(String item) {
    return Draggable<String>(
      data: item,
      child: Image.asset('assets/$item.png', height: 50, width: 50),
      feedback: Image.asset('assets/$item.png', height: 50, width: 50),
      childWhenDragging: Container(),
    );
  }

  Widget buildDragTarget(String bin) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          width: 100,
          color: binColor(bin),
          child: Center(child: Text(bin)),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        int index = wasteItems.indexOf(data);
        if (correctBins[index] == bin) {
          setState(() {
            score += 100;
            wasteItems.removeAt(index);
            correctBins.removeAt(index);
            _confettiController.play();
            showInsight(data, true);
            checkLevelCompletion();
          });
        } else {
          showInsight(data, false);
        }
      },
    );
  }

  Color binColor(String bin) {
    switch (bin) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void showInsight(String item, bool correct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(correct ? 'Correct!' : 'Incorrect!'),
          content: Text(correct ? getInsight(item) : getWrongInsight(item)),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String getInsight(String item) {
    switch (item) {
      case 'apple':
        return 'Apples are biodegradable and should go in the green bin.';
      case 'banana_peel':
        return 'Banana peels are biodegradable and should go in the green bin.';
      case 'newspaper':
        return 'Newspapers are recyclable and should go in the blue bin.';
      case 'bottle':
        return 'Plastic bottles are recyclable and should go in the blue bin.';
      case 'magazine':
        return 'Magazines are recyclable and should go in the blue bin.';
      case 'plastic_bag':
        return 'Plastic bags are recyclable and should go in the blue bin.';
      case 'battery':
        return 'Batteries are hazardous and should go in the red bin.';
      case 'mask':
        return 'Used masks are sanitary waste and should go in the red bin.';
      case 'syringe':
        return 'Used syringes are medical waste and should go in the red bin.';
      case 'light_bulb':
        return 'Light bulbs are hazardous and should go in the red bin.';
      // Add more insights as needed
      default:
        return 'Information not available.';
    }
  }

  String getWrongInsight(String item) {
    switch (item) {
      case 'apple':
        return 'Apples are biodegradable and cannot go in this bin.';
      case 'banana_peel':
        return 'Banana peels are biodegradable and cannot go in this bin.';
      case 'newspaper':
        return 'Newspapers are recyclable and cannot go in this bin.';
      case 'bottle':
        return 'Plastic bottles are recyclable and cannot go in this bin.';
      case 'magazine':
        return 'Magazines are recyclable and cannot go in this bin.';
      case 'plastic_bag':
        return 'Plastic bags are recyclable and cannot go in this bin.';
      case 'battery':
        return 'Batteries are hazardous and cannot go in this bin.';
      case 'mask':
        return 'Used masks are sanitary waste and cannot go in this bin.';
      case 'syringe':
        return 'Used syringes are medical waste and cannot go in this bin.';
      case 'light_bulb':
        return 'Light bulbs are hazardous and cannot go in this bin.';
      // Add more wrong insights as needed
        default:
          return 'This item cannot go in this bin.';
      }
    }
  
    void checkLevelCompletion() {
      if (wasteItems.isEmpty) {
        widget.saveProgress(widget.level + 1);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Level Completed!'),
              content: Text('You have completed Level ${widget.level}!'),
              actions: [
                TextButton(
                  child: Text('Next Level'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelScreen(level: widget.level + 1, saveProgress: widget.saveProgress),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
  
  // Remaining asset list
  final List<String> assets = [
    'apple.png', 'banana_peel.png', 'newspaper.png', 'bottle.png', 'magazine.png',
    'plastic_bag.png', 'battery.png', 'mask.png', 'syringe.png', 'light_bulb.png',
    // Add more assets as needed
  ];
  
