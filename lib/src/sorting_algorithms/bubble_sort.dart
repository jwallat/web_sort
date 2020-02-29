import 'dart:ui';

import 'package:tuple/tuple.dart';
import 'package:web_sort/src/sorting_algorithms/sorting_algorithm.dart';
import 'package:web_sort/src/widgets/sorting_element.dart';

class BubbleSort extends SortingAlgorithm {
  @override
  List<SortingElement> data;
  final Color defaultColor;
  final Color highlightColor;
  final Color compareColor;
  List<Tuple2<Command, int>> commands = List();

  BubbleSort(
      {this.data, this.defaultColor, this.highlightColor, this.compareColor})
      : super();

  @override
  List<Tuple2> solveAndGetSteps() {
    sort();
    return commands;
  }

  void sort() {
    List<int> values = [];
    for (SortingElement ele in data) {
      values.add(ele.value);
    }
    int len = data.length;
    bool swapped = true;
    while (swapped) {
      swapped = false;
      for (int i = 0; i < len - 1; i++) {
        // move iter
        commands.add(Tuple2<Command, int>(Command.MOVE_ITER, i));
        // compare
        commands.add(Tuple2<Command, int>(Command.COMPARE, i + 1));
        if (values[i] > values[i + 1]) {
          // switch position
          commands.add(Tuple2<Command, int>(Command.SWITCH_POSITION, i + 1));
          swap(values, i, i + 1);
          swapped = true;
        }
      }
    }
  }
}
