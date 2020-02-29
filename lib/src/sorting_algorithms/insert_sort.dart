import 'dart:ui';

import 'package:tuple/tuple.dart';
import 'package:web_sort/src/sorting_algorithms/sorting_algorithm.dart';
import 'package:web_sort/src/widgets/sorting_element.dart';

class InsertSort extends SortingAlgorithm {
  @override
  List<SortingElement> data;
  final Color defaultColor;
  final Color highlightColor;
  final Color compareColor;
  List<Tuple2<Command, int>> commands = List();

  InsertSort(
      {this.data, this.defaultColor, this.highlightColor, this.compareColor})
      : super();

  @override
  List<Tuple2> solveAndGetSteps() {
    sort();
    return commands;
  }

  void sort() {
    // get values as array
    List<int> values = [];
    for (SortingElement ele in data) {
      values.add(ele.value);
    }

    // actual algorithm

    int k;
    for (int i = 0; i < values.length; i++) {
      for (int j = values.length - 1; j > 0; j--) {
        commands.add(Tuple2<Command, int>(Command.MOVE_ITER, j));

        commands.add(Tuple2<Command, int>(Command.COMPARE, j - 1));
        if (values[j - 1] > values[j]) {
          k = values[j];
          commands.add(Tuple2<Command, int>(Command.SWITCH_POSITION, j - 1));
          values[j] = values[j - 1];
          values[j - 1] = k;
        }
      }
    }
  }
}
