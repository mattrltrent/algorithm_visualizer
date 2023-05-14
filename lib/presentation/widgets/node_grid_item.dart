import 'package:algorithm_visualizer/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/node.dart';

class NodeGridItem extends ConsumerStatefulWidget {
  const NodeGridItem({super.key, required this.node, required this.row, required this.col});

  final Node node;
  final int row;
  final int col;

  @override
  NodeGridItemState createState() => NodeGridItemState();
}

class NodeGridItemState extends ConsumerState<NodeGridItem> {
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

  // todo: KEY matching against store key after future delayed
  void updateTile() async {
    // print('updateTile : ${UniqueKey()}');
    if (widget.node.delay != Duration.zero) {
      await Future.delayed(widget.node.delay);
    }
    if (ref.read(matrixProvider).key.toString() != widget.node.key.toString()) return;
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
