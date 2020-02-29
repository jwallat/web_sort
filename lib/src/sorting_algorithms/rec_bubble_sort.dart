import 'dart:ui';

import 'package:tuple/tuple.dart';
import 'package:web_sort/src/sorting_algorithms/sorting_algorithm.dart';
import 'package:web_sort/src/widgets/sorting_element.dart';

class RecBubbleSort extends SortingAlgorithm {
  @override
  List<SortingElement> data;
  final Color defaultColor;
  final Color highlightColor;
  final Color compareColor;
  List<Tuple2<Command, int>> commands = List();

  RecBubbleSort(
      {this.data, this.defaultColor, this.highlightColor, this.compareColor})
      : super();

  @override
  List<Tuple2> solveAndGetSteps() {
    List<int> values = [];
    for (SortingElement ele in data) {
      values.add(ele.value);
    }
    int len = data.length;

    sort(values, len);
    return commands;
  }

  void sort(List<int> values, int n) {
    if (n == 1) {
      return;
    }

    for (int i = 0; i < n - 1; i++) {
      commands.add(Tuple2<Command, int>(Command.MOVE_ITER, i));

      commands.add(Tuple2<Command, int>(Command.COMPARE, i + 1));
      if (values[i] > values[i + 1]) {
        commands.add(Tuple2<Command, int>(Command.SWITCH_POSITION, i + 1));
        swap(values, i, i + 1);
      }
    }

    sort(values, n - 1);
  }
}
