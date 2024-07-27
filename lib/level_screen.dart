import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'levels.dart';

class LevelScreen extends StatefulWidget {
  final int level;
  final Function(int) saveProgress;

  LevelScreen({required this.level, required this.saveProgress});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int score = 0;
  ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 1));

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LevelRoadmapScreen()),
          (Route<dynamic> route) => route.isFirst,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Level ${widget.level}'),
          backgroundColor: Colors.teal.shade100,
        ),
        body: Container(
          color: Colors.teal.shade50,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Score: $score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          wasteItems.map((item) => buildDraggable(item)).toList(),
                    ),
                  ),
                  if (wasteItems.isEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.teal.shade900, backgroundColor: Colors.teal.shade100,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LevelRoadmapScreen()),
                          (Route<dynamic> route) => route.isFirst,
                        );
                      },
                      child: Text('Next Level'),
                    ),
                ],
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [Colors.green.shade200, Colors.blue.shade200, Colors.red.shade200],
              ),
            ],
          ),
        ),
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
          decoration: BoxDecoration(
            color: binColor(bin),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              bin,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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
        return Colors.green.shade700;
      case 'blue':
        return Colors.blue.shade700;
      case 'red':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade200;
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
      default:
        return 'Information not available.';
    }
  }

  void checkLevelCompletion() {
    if (wasteItems.isEmpty) {
      widget.saveProgress(widget.level + 1);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Level Complete!'),
            content: Text('You have completed this level. Well done!'),
            actions: [
              TextButton(
                child: Text('Next Level'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LevelRoadmapScreen()),
                    (Route<dynamic> route) => route.isFirst,
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
