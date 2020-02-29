import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:threading/threading.dart';
import 'package:tuple/tuple.dart';
import 'package:web_sort/src/sorting_algorithms/bubble_sort.dart';
import 'package:web_sort/src/sorting_algorithms/insert_sort.dart';
import 'package:web_sort/src/sorting_algorithms/rec_bubble_sort.dart';
import 'package:web_sort/src/sorting_algorithms/sorting_algorithm.dart';
import 'package:web_sort/src/widgets/sorting_element.dart';

class SortingScreen extends StatefulWidget {
  @override
  _SortingScreenState createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  List<SortingElement> data = [];
  List<Tuple2<Command, int>> steps = [];
  int numTotalSteps;
  SortingAlgorithm algorithm;
  bool buttonPressed = false;
  int mulitplier = 1;
  String selectedAlgorithmName = "BubbleSort";

  int elementWidth = 50;

  Thread solvingThread;

  final Color defaultColor = Colors.blue;
  final Color highlightColor = Colors.red;
  final Color compareColor = Colors.yellow;

  @override
  void initState() {
    super.initState();

    loadNewAlgorithm('BubbleSort');

    setState(() {
      solvingThread = Thread(doSolving);
    });
  }

  List<SortingElement> sampleData() {
    List<SortingElement> elements = [];
    var rng = Random();
    for (var i = 0; i < 30; i++) {
      int val = rng.nextInt(200);

      elements.add(SortingElement(
        color: defaultColor,
        value: val,
        width: elementWidth,
      ));
    }

    return elements;
  }

  loadNewAlgorithm(String algorithmName) {
    print('In load new Algorithm');
    if (solvingThread != null) {
      solvingThread.interrupt();
    }

    // sample new data
    List<SortingElement> newData = sampleData();

    SortingAlgorithm newAlgorithm;
    switch (algorithmName) {
      case "InsertSort":
        newAlgorithm = InsertSort(
            data: newData,
            defaultColor: defaultColor,
            highlightColor: highlightColor,
            compareColor: compareColor);
        break;
      case "RecBubbleSort":
        newAlgorithm = RecBubbleSort(
            data: newData,
            defaultColor: defaultColor,
            highlightColor: highlightColor,
            compareColor: compareColor);
        break;
      default:
        newAlgorithm = BubbleSort(
            data: newData,
            defaultColor: defaultColor,
            highlightColor: highlightColor,
            compareColor: compareColor);
        break;
    }

    // get steps
    List<Tuple2<Command, int>> newSteps = newAlgorithm.solveAndGetSteps();

    // set state with new data, steps and the algorithm
    setState(() {
      data = newData;
      algorithm = newAlgorithm;
      steps = newSteps;
      selectedAlgorithmName = algorithmName;
      numTotalSteps = steps.length;
      buttonPressed = false;
    });
  }

  void doSolving() async {
    print('Thread starting now....');
    while (steps.isNotEmpty) {
      solve();

      await Thread.sleep(
          (1000 / (mulitplier * mulitplier * mulitplier)).round());
    }
  }

  void solve() async {
    List<SortingElement> adjustedData = algorithm.handleCommand(steps[0]);
    List<Tuple2<Command, int>> adjustedSteps = [];
    for (Tuple2 element in steps) {
      adjustedSteps.add(element);
    }
    adjustedSteps.removeAt(0);
    setState(() {
      data = adjustedData;
      steps = adjustedSteps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double padding = 20;
      double margin = 20;
      elementWidth = 50;
      print(constraints.maxWidth);

      if (constraints.maxWidth < 600) {
        padding = 8;
        margin = 8;
        elementWidth = 10;
      }

      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(padding),
          margin: EdgeInsets.all(margin),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Sorting Algorithm: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedAlgorithmName,
                    icon: Icon(Icons.arrow_drop_down),
                    items: <String>[
                      'BubbleSort',
                      'InsertSort',
                      'RecBubbleSort',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (algorithmName) {
                      loadNewAlgorithm(algorithmName);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(
                    flex: 2,
                  ),
                  RaisedButton(
                    child: buttonPressed
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        buttonPressed = !buttonPressed;
                      });
                      if (solvingThread.isRunning) {
                        solvingThread.interrupt();
                      } else {
                        setState(() {
                          solvingThread = Thread(doSolving);
                          solvingThread.start();
                        });
                      }
                    },
                  ),
                  Spacer(),
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () => loadNewAlgorithm(selectedAlgorithmName),
                  ),
                  Spacer(),
                  Slider(
                    value: mulitplier.toDouble(),
                    min: 1,
                    max: 10,
                    label: '${mulitplier.round()}',
                    onChanged: (double value) {
                      setState(() {
                        mulitplier = value.round();
                      });
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
              RoundedProgressBar(
                style: RoundedProgressBarStyle(borderWidth: 0, widthShadow: 0),
                margin: EdgeInsets.symmetric(vertical: 16),
                borderRadius: BorderRadius.circular(24),
                percent: (100 - (steps.length / numTotalSteps) * 100)
                        .roundToDouble() +
                    1,
              ),
            ],
          ),
        ),
      );
    });
  }
}
