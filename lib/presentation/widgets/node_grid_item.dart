import 'package:algorithm_visualizer/presentation/widgets/init_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/node.dart';

class NodeGridItem extends StatefulWidget {
  const NodeGridItem({Key? key, required this.matrix, required this.node, required this.row, required this.col})
      : super(key: key);

  final Node node;
  final List<List<Node>> matrix;
  final int row;
  final int col;

  @override
  _NodeGridItemState createState() => _NodeGridItemState();
}

class _NodeGridItemState extends State<NodeGridItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _sizeAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NodeGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.node.type == NodeType.visited && widget.node.type != oldWidget.node.type) {
      print("HEREHERHEER");
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 * _sizeAnimation.value,
          child: AnimatedContainer(
            margin: const EdgeInsets.all(0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.node.type.color,
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
          ),
        );
      },
    );
  }
}
