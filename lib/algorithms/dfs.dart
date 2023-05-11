import 'dart:math';

import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:dartz/dartz.dart';

import '../core/results.dart';
import '../domain/entities/node.dart';

class PointNode {
  final Point<int> point;
  final PointNode? parent;
  const PointNode(this.point, this.parent);
}

class Dfs implements Algorithm {
  @override
  String name() => "Depth First Search";

  @override
  List<MatrixUpdate> update_list = [];
  static List<Point<int>> adjcent_Moves = const [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];
  AlgorithmStats run(List<List<Node>> matrix, Point<int> start, Point<int> end) {
    final stopwatch = Stopwatch()..start();

    //! provided the `input` matrix, return `AlgorithmStats` object.
    // Example (trivial) output:
    int matrix_width = matrix[0].length;
    int matrix_height = matrix.length;

    PointNode current = PointNode(Point<int>(start.x, start.y), null);
    DFS(matrix, current);
    //! Return Path
    if (update_list.isNotEmpty)
      return AlgorithmStats(path: update_list, timeTakenMicroSec: stopwatch.elapsedMicroseconds, pathFound: true);

    //! Return No Path
    return AlgorithmStats(path: update_list, timeTakenMicroSec: stopwatch.elapsedMicroseconds, pathFound: false);
    // }
  }

  bool DFS(List<List<Node>> matrix, PointNode node) {
    if (node.point.x < 0 ||
        node.point.x >= matrix[0].length ||
        node.point.y < 0 ||
        node.point.y >= matrix.length ||
        matrix[node.point.x][node.point.y].type == NodeType.visited ||
        matrix[node.point.x][node.point.y].type == NodeType.wall) {
      return false;
    }
    if (matrix[node.point.x][node.point.y].type == NodeType.end) {
      //if the node is the end node, then we have found the path.
      PointNode? current = node;
      if (update_list.isNotEmpty) update_list.removeAt(0);
      current = current.parent;
      while (current!.parent != null) {
        update_list.add(MatrixUpdate(row: current.point.x, col: current.point.y, updatedTo: NodeType.path));
        current = current.parent;
      }
      return true;
    }
    matrix[node.point.x][node.point.y] = const Node(NodeType.visited);
    update_list.add(MatrixUpdate(row: node.point.x, col: node.point.y, updatedTo: NodeType.visited));
    for (Point<int> next in adjcent_Moves) {
      //add every adjcent node to the queue.
      if (DFS(matrix, (PointNode(Point(node.point.x + next.x, node.point.y + next.y), node)))) return true;
    }
    return false;
  }
}
