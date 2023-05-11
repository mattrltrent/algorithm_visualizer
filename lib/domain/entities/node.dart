import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NodeType {
  cell,
  visited,
  wall,
  start,
  end,
  path,
}

class Node extends Equatable {
  final NodeType type;
  final Duration delay;

  const Node(this.type, {this.delay = Duration.zero});

  Node clone() => Node(type, delay: delay);

  @override
  List<Object?> get props => [type, delay];
}

extension NodeTypeColor on NodeType {
  Color get color {
    switch (this) {
      case NodeType.cell:
        return Colors.white;
      case NodeType.visited:
        return Colors.orange;
      case NodeType.wall:
        return Colors.black;
      case NodeType.start:
        return Colors.green;
      case NodeType.end:
        return Colors.red;
      case NodeType.path:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}
