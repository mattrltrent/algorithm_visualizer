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
        return Color(0xffF9F9F9);
      case NodeType.visited:
        return Color(0xff6C9BCF);
      case NodeType.wall:
        return Colors.black;
      case NodeType.start:
        return Color(0xff98D8AA);
      case NodeType.end:
        return Color(0xffFF6D60);
      case NodeType.path:
        return Color(0xffBE5A83);
      default:
        return Color.fromARGB(255, 28, 33, 72);
    }
  }
}
