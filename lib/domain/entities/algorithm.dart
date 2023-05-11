import 'dart:math';

import 'package:algorithm_visualizer/core/results.dart';
import 'package:dartz/dartz.dart';

import 'node.dart';

/// Interface for how to implement algorithm solutions adhering to the grid visualization.
abstract class Algorithm {
  AlgorithmStats run(List<List<Node>> input, Point<int> start, Point<int> end);
  String name();
}

/// Algorithm statistics.
///
/// [path] is either a list of [MatrixUpdate]s found during pathfinding, or a [NoPathFailure].
/// [timeTakenMicroSec] is the time taken to run the algorithm in microseconds.
class AlgorithmStats {
  final int timeTakenMicroSec;
  final List<MatrixUpdate> path;
  final bool pathFound;

  const AlgorithmStats({
    required this.timeTakenMicroSec,
    required this.path,
    required this.pathFound,
  });
}

class MatrixUpdate {
  final int row;
  final int col;
  final NodeType updatedTo;

  const MatrixUpdate({
    required this.row,
    required this.col,
    required this.updatedTo,
  });
}
