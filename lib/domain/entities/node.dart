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

  const Node(this.type);

  Node clone() => Node(type);

  @override
  List<Object?> get props => [type];
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
