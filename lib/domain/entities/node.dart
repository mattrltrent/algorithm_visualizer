import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NodeType {
  unvisited,
  visited,
  wall,
  start,
  end,
}

class Node extends Equatable {
  final NodeType type;
  const Node(this.type);
  @override
  List<Object?> get props => [type];
}

extension NodeTypeColor on NodeType {
  Color get color {
    switch (this) {
      case NodeType.unvisited:
        return Colors.white;
      case NodeType.visited:
        return Colors.orange;
      case NodeType.wall:
        return Colors.grey;
      case NodeType.start:
        return Colors.green;
      case NodeType.end:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
