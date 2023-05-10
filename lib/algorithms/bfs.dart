import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:dartz/dartz.dart';

import '../domain/entities/node.dart';

class Bfs extends Algorithm {
  @override
  AlgorithmStats run(List<List<Node>> input) {
    // todo: provided the `input` matrix, return `AlgorithmStats` object.
    // Example (trivial) output:
    return const AlgorithmStats(
      timeTakenMs: 0,
      path: Right([]),
    );
  }
}
