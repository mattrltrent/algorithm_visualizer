import 'package:algorithm_visualizer/domain/entities/node.dart';

import 'dart:math';

import '../domain/entities/algorithm.dart';

class PointNode {
  final Point<int> point;
  final PointNode? parent;
  const PointNode(this.point, this.parent);
}



class Dijkstra implements Algorithm {
  @override
  String name() => "Dijkstra's Algorithm";

  @override
  AlgorithmStats run(List<List<Node>> input, Point<int> start, Point<int> end) {
    // TODO: implement algorithm and return `AlgorithmStats` obj with results.

    
    // Dijkstra's Algorithm
    var distance = List<List<int>>.generate(input.length, (i) => List<int>.generate(input[i].length, (j) => 0));




    //! Return Path


    //! Return No Path Found
    throw UnimplementedError();
  }

  @override
  Algorithm clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }
}
