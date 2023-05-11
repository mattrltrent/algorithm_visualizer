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

class Bfs extends Algorithm {
  @override
  AlgorithmStats run(List<List<Node>> matrix, Point<int> start, Point<int> end) {
    //! provided the `input` matrix, return `AlgorithmStats` object.
    // Example (trivial) output:
    int matrix_width = matrix[0].length;
    int matrix_height = matrix.length;
    List<MatrixUpdate> update_list = [];
    const List<Point<int>> adjcent_Moves = [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];

    Queue<Point<int>> futureNodes = Queue<Point<int>>();
    futureNodes.add(Point<int>(start.x, start.y));

    while (futureNodes.isNotEmpty) {
      Point<int> current = futureNodes.removeFirst();
      //check if the current node is a unwanted node.
      if (current.x < 0 ||
          current.x >= matrix_width ||
          current.y < 0 ||
          current.y >= matrix_height ||
          matrix[current.x][current.y].type == NodeType.visited ||
          matrix[current.x][current.y].type == NodeType.wall) {
        // if (update_list.isNotEmpty) update_list.removeLast();
        continue;
      }
      update_list.add(MatrixUpdate(row: current.x, col: current.y, updatedTo: NodeType.visited));
      if (matrix[current.x][current.y].type == NodeType.end) {
        //! Return Path

        if (update_list.isNotEmpty) update_list.removeLast();
        if (update_list.isNotEmpty) update_list.removeAt(0);
        return AlgorithmStats(path: Right(update_list), timeTakenMs: 123);
      }
      for (Point<int> next in adjcent_Moves) {
        //add every adjcent node to the queue.
        futureNodes.add(Point(current.x + next.x, current.y + next.y));
      }
      //Set Current Node to be visited.
      matrix[current.x][current.y] = const Node(NodeType.visited);
    }

    //! Return No Path
    return AlgorithmStats(path: Left(NoPath()), timeTakenMs: 123);
    // }

    return const AlgorithmStats(
      timeTakenMs: 0,
      path: Right([]), // path: Left(NoPath()) OR path: Right([MatrixUpdate(...), MatrixUpdate(...), ...])
    );
  }
}
