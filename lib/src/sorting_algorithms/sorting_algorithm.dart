import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:web_sort/src/widgets/sorting_element.dart';

enum Command {
  COMPARE, // current iter with index
  MOVE_ITER, // to new index
  SWITCH_POSITION, // current iter item with index
}

abstract class SortingAlgorithm {
  List<SortingElement> data;
  List<Tuple2<Command, int>> commands;
  final Color defaultColor;
  final Color highlightColor;
  final Color compareColor;

  SortingAlgorithm(
      {this.data, this.defaultColor, this.highlightColor, this.compareColor});

  /// If this function is called, the sorting algorithm should do one interation.
  /// I.e. show one comparison in the colors of the data. After that, the data
  /// should be returned, so that the sorting_screen can call set_state() on the
  /// changed data.
  List<Tuple2> solveAndGetSteps();

  List<SortingElement> handleCommand(Tuple2<Command, int> t) {
    Command c = t.item1;
    int index = t.item2;
    if (c == Command.COMPARE) {
      // set color to highlight color
      data[index] = SortingElement(
        color: compareColor,
        value: data[index].value,
        width: data[index].width,
      );
    } else if (c == Command.MOVE_ITER) {
      // change highlighted element
      // previously highlighted or compared color set back to default
      for (SortingElement element in data) {
        if (element.color != defaultColor) {
          int occ = data.indexOf(element);
          data[occ] = SortingElement(
            color: defaultColor,
            value: data[occ].value,
            width: data[occ].width,
          );
        }
      }
      // highlighted color set to the new iter
      data[index] = SortingElement(
        color: highlightColor,
        value: data[index].value,
        width: data[index].width,
      );
    } else if (c == Command.SWITCH_POSITION) {
      // find highlighted element index
      int highlightedIndex = 0;
      for (SortingElement element in data) {
        if (element.color == highlightColor) {
          highlightedIndex = data.indexOf(element);
          break;
        }
      }
      int highlightedValue = data[highlightedIndex].value;
      // set color back to default
      data[highlightedIndex] = SortingElement(
        color: defaultColor,
        value: data[index].value,
        width: data[index].width,
      );
      // set new highglighted elements color accordingly
      data[index] = SortingElement(
        color: highlightColor,
        value: highlightedValue,
        width: data[index].width,
      );
    } else {
      print('Not recognized command: $c');
    }
    return data;
  }

  void swap(List<int> data, int i, int j) {
    int tmp = data[i];
    data[i] = data[j];
    data[j] = tmp;
  }
}
