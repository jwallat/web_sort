import 'package:flutter/material.dart';
import 'package:web_sort/src/screens/sorting_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SortingScreen(),
    );
  }
}
