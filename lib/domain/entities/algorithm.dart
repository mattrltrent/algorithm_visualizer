import 'package:algorithm_visualizer/core/results.dart';
import 'package:dartz/dartz.dart';

import 'node.dart';

abstract class Algorithm {
  AlgorithmStats run(List<List<Node>> input);
}

class AlgorithmStats {
  final int visitedNodes;
  final int pathLength;
  final int timeTakenMs;
  final Either<NoPathFailure, List<MatrixUpdate>> path;

  const AlgorithmStats({
    required this.visitedNodes,
    required this.pathLength,
    required this.timeTakenMs,
    required this.path,
  });
}

class MatrixUpdate {
  final int row;
  final int col;
  final Node updatedTo;

  const MatrixUpdate({
    required this.row,
    required this.col,
    required this.updatedTo,
  });
}
