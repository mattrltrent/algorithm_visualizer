import 'package:algorithm_visualizer/core/results.dart';
import 'package:dartz/dartz.dart';

import 'node.dart';

/// Interface for how to implement algorithm solutions adhering to the grid visualization.
abstract class Algorithm {
  AlgorithmStats run(List<List<Node>> input);
}

/// Algorithm statistics.
///
/// [path] is either a list of [MatrixUpdate]s found during pathfinding, or a [NoPathFailure].
/// [timeTakenMs] is the time taken to run the algorithm in milliseconds.
class AlgorithmStats {
  final int timeTakenMs;
  final Either<NoPathFailure, List<MatrixUpdate>> path;

  const AlgorithmStats({
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
