import 'package:algorithm_visualizer/presentation/widgets/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/styles/typography.dart';
import '../../domain/entities/node.dart';

class NodePalette extends StatefulWidget {
  const NodePalette({super.key, required this.onNodeSelected});

  final Function(NodeType nodeType) onNodeSelected;

  @override
  State<NodePalette> createState() => _NodePaletteState();
}

class _NodePaletteState extends State<NodePalette> {
  int _selectedButtonIndex = 0;
  final List<String> _buttonNames = ["Start node", "Target node", "Walls", "Eraser"];
  final List<NodeType> _buttonTypes = [NodeType.start, NodeType.end, NodeType.wall, NodeType.cell];

  void _toggleButton(int index) {
    setState(() {
      widget.onNodeSelected(_buttonTypes[index]);
      _selectedButtonIndex = index;
    });
  }

  Widget buildBody(BuildContext context) {
    List<Widget> nodeButtons = [];
    for (int i = 0; i < _buttonNames.length; i++) {
      nodeButtons.add(
        AnimatedScale(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 150),
          scale: _selectedButtonIndex == i ? 1.4 : 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TouchableOpacity(
                  onTap: () => _toggleButton(i),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _buttonTypes[i].color,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit the map",
                style: font1.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedButtonIndex == -1 ? "Nothing" : _buttonNames[_selectedButtonIndex],
                style: font3.copyWith(color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: nodeButtons,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffFFDBA4),
          borderRadius: BorderRadius.circular(5),
        ),
        child: buildBody(context),
      );
}
