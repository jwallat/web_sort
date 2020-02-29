import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SortingElement extends StatefulWidget {
  final Color color;
  final int value;
  final int width;

  const SortingElement({Key key, this.color, this.value, this.width})
      : super(key: key);

  @override
  _SortingElementState createState() => _SortingElementState();
}

class _SortingElementState extends State<SortingElement> {
  @override
  Widget build(BuildContext context) {
    print('Width: ${widget.width}');
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: widget.value.toDouble(),
            width: widget.width.toDouble(),
            color: widget.color,
          ),
          Divider(),
          Text(
            widget.value.toString(),
            style: TextStyle(
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}
