import 'package:algorithm_visualizer/presentation/widgets/init_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

class NodeGridItem extends StatelessWidget {
  const NodeGridItem({super.key, required this.matrix, required this.node, required this.row, required this.col});

  final Node node;
  final List<List<Node>> matrix;
  final int row;
  final int col;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: node.type.color,
        border: Border(
          top: BorderSide(
            color: Colors.blue.withOpacity(0.5),
            width: row == 0 ? 0.5 : 0,
          ),
          left: BorderSide(
            color: Colors.blue.withOpacity(0.5),
            width: col == 0 ? 0.5 : 0,
          ),
          right: BorderSide(
            color: Colors.blue.withOpacity(0.5),
            width: col == matrix[0].length - 1 ? 0.5 : 0,
          ),
          bottom: BorderSide(
            color: Colors.blue.withOpacity(0.5),
            width: row == matrix.length - 1 ? 0.5 : 0,
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: node.type == NodeType.start
              ? const Icon(
                  CupertinoIcons.play,
                  color: Colors.white,
                )
              : node.type == NodeType.end
                  ? const Icon(
                      CupertinoIcons.flag,
                      color: Colors.white,
                    )
                  : null,
        ),
      ),
    );
  }
}
