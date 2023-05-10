import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:dartz/dartz.dart';

import '../domain/entities/node.dart';

class Bfs extends Algorithm {
  @override
  AlgorithmStats run(List<List<Node>> input) {
    print('Running BFS');
    return const AlgorithmStats(
      visitedNodes: 0,
      pathLength: 0,
      timeTakenMs: 0,
      path: Right([]),
    );
  }
}
