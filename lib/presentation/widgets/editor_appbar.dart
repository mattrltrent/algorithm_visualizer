import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/core/styles/typography.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

class EditorAppBar extends StatefulWidget {
  const EditorAppBar({Key? key, required this.onNodeSelected}) : super(key: key);

  final Function(NodeType nodeType) onNodeSelected;

  @override
  EditorAppBarState createState() => EditorAppBarState();
}

class EditorAppBarState extends State<EditorAppBar> {
  int _selectedButtonIndex = 3;
  final List<String> _nodeNames = ['Start', 'End', 'Visited', 'Wall'];
  final List<NodeType> _buttonColors = [NodeType.start, NodeType.end, NodeType.visited, NodeType.wall];

  void _toggleButton(int index) {
    setState(() {
      if (_selectedButtonIndex == index) {
        // if the same button is tapped twice, unselect it
        widget.onNodeSelected(NodeType.unvisited);
        _selectedButtonIndex = -1;
      } else {
        widget.onNodeSelected(_buttonColors[index]);
        _selectedButtonIndex = index;
      }
    });
  }

  Widget genNodePallet() {
    List<Widget> nodeButtons = [];
    for (int i = 0; i < _nodeNames.length; i++) {
      nodeButtons.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: AnimatedScale(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 250),
              scale: _selectedButtonIndex == i ? 1.5 : 1,
              child: IconButton(
                icon: Icon(Icons.circle, color: _buttonColors[i].color),
                onPressed: () {
                  _toggleButton(i);
                },
                tooltip: 'Select ${_nodeNames[i]}',
              ),
            ),
          ),
          Text(
            _nodeNames[i],
            style: font3.copyWith(color: Colors.white),
          ),
        ],
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: nodeButtons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: genNodePallet(),
    );
  }
}
