import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

class NodeGridItem extends StatefulWidget {
  const NodeGridItem({super.key, required this.matrix, required this.node, required this.row, required this.col});

  final Node node;
  final List<List<Node>> matrix;
  final int row;
  final int col;

  @override
  State<NodeGridItem> createState() => _NodeGridItemState();
}

class _NodeGridItemState extends State<NodeGridItem> {
  late Color currColor;

  @override
  void initState() {
    currColor = widget.node.type.color;
    super.initState();
  }

  @override
  void didUpdateWidget(NodeGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTile();
  }

  void updateTile() async {
    if (widget.node.delay != Duration.zero) await Future.delayed(widget.node.delay);
    if (mounted) {
      setState(() {
        currColor = widget.node.type.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(1),
      duration: const Duration(milliseconds: 125),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: currColor,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: widget.row == 0 ? 0.5 : 0,
          ),
          left: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: widget.col == 0 ? 0.5 : 0,
          ),
          right: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: widget.col == widget.matrix[0].length - 1 ? 0.5 : 0,
          ),
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: widget.row == widget.matrix.length - 1 ? 0.5 : 0,
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: widget.node.type == NodeType.start
              ? const Icon(
                  CupertinoIcons.play,
                  color: Colors.white,
                )
              : widget.node.type == NodeType.end
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
