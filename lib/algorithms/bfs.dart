import 'dart:collection';
import 'dart:math';

import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:dartz/dartz.dart';

import '../core/results.dart';
import '../domain/entities/node.dart';

class BfsNode extends Node {
  @override
  final NodeType type;
  final Point<int>? parent;
  const BfsNode(this.type, this.parent) : super(type);
  @override
  List<Object?> get props => [type, parent];
}

class PointNode {
  final Point<int> point;
  final PointNode? parent;
  const PointNode(this.point, this.parent);
}

class Bfs implements Algorithm {
  @override
  String name() => "Breadth First Search";

  @override
  AlgorithmStats run(List<List<Node>> matrix, Point<int> start, Point<int> end) {
    final stopwatch = Stopwatch()..start();
    //! provided the `input` matrix, return `AlgorithmStats` object.
    // Example (trivial) output:
    int matrix_width = matrix[0].length;
    int matrix_height = matrix.length;
    List<MatrixUpdate> update_list = [];
    const List<Point<int>> adjcent_Moves = [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];

    Queue<PointNode> futureNodes = Queue<PointNode>();
    futureNodes.add(PointNode(Point<int>(start.x, start.y), null));

    while (futureNodes.isNotEmpty) {
      PointNode current = futureNodes.removeFirst();
      //check if the current node is a unwanted node.
      if (current.point.x < 0 ||
          current.point.x >= matrix_width ||
          current.point.y < 0 ||
          current.point.y >= matrix_height ||
          matrix[current.point.x][current.point.y].type == NodeType.visited ||
          matrix[current.point.x][current.point.y].type == NodeType.wall) {
        continue;
      }
      update_list.add(MatrixUpdate(row: current.point.x, col: current.point.y, updatedTo: NodeType.visited));
      if (matrix[current.point.x][current.point.y].type == NodeType.end) {
        //! Return Path

        if (update_list.isNotEmpty) update_list.removeLast();
        if (update_list.isNotEmpty) update_list.removeAt(0);
        if (current.parent != null) current = current.parent!;
        while (current.parent != start) {
          if (current.parent == null) break;
          update_list.add(MatrixUpdate(row: current.point.x, col: current.point.y, updatedTo: NodeType.path));
          current = current.parent!;
        }
        return AlgorithmStats(path: update_list, timeTakenMicroSec: stopwatch.elapsedMicroseconds, pathFound: true);
      }
      for (Point<int> next in adjcent_Moves) {
        //add every adjcent node to the queue.
        futureNodes.add(PointNode(Point(current.point.x + next.x, current.point.y + next.y), current));
      }
      //Set Current Node to be visited.
      matrix[current.point.x][current.point.y] = const Node(NodeType.visited);
    }

    //! Return No Path
    return AlgorithmStats(path: update_list, timeTakenMicroSec: stopwatch.elapsedMicroseconds, pathFound: false);
  }
}
