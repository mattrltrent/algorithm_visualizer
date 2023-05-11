import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/core/styles/typography.dart';
import 'package:algorithm_visualizer/presentation/widgets/touchable_shrink.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

class EditorAppBar extends StatefulWidget {
  const EditorAppBar({Key? key, required this.onNodeSelected}) : super(key: key);

  final Function(NodeType nodeType) onNodeSelected;

  @override
  EditorAppBarState createState() => EditorAppBarState();
}

class EditorAppBarState extends State<EditorAppBar> {
  int _selectedButtonIndex = 0;
  final List<String> _buttonNames = ["Start", "End", "Wall on/off", "Clear"];
  final List<NodeType> _buttonColors = [NodeType.start, NodeType.end, NodeType.wall, NodeType.cell];

  void _toggleButton(int index) {
    setState(() {
      if (_selectedButtonIndex == index) {
        // todo: make this do no editing instead
        widget.onNodeSelected(NodeType.cell);
        _selectedButtonIndex = -1;
      } else {
        widget.onNodeSelected(_buttonColors[index]);
        _selectedButtonIndex = index;
      }
    });
  }

  Widget genNodePallet() {
    List<Widget> nodeButtons = [];
    for (int i = 0; i < _buttonNames.length; i++) {
      nodeButtons.add(
        AnimatedScale(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 250),
          scale: _selectedButtonIndex == i ? 1.25 : 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TouchableShrink(
                  onTap: () => _toggleButton(i),
                  child: Container(
                    color: _buttonColors[i].color,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(_selectedButtonIndex == -1 ? "Nothing" : _buttonNames[_selectedButtonIndex],
              style: font2.copyWith(color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: nodeButtons,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: genNodePallet(),
    );
  }
}
