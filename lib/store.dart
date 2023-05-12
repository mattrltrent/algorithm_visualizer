import 'dart:async';
import 'dart:math';

import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:algorithm_visualizer/domain/entities/node.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Matrix {
  final List<List<Node>> _matrix;

  Matrix(this._matrix);

  List<List<Node>> get matrixElements => _matrix;

  factory Matrix.deepCopy(Matrix other) {
    final matrixCopy = List.generate(
      other.rows,
      (i) => List.generate(other.cols, (j) => other.get(i, j).deepCopy()),
    );
    return Matrix(matrixCopy);
  }

  void clearPathfinding() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        switch (_matrix[i][j].type) {
          case NodeType.visited:
          case NodeType.path:
            _matrix[i][j] = const Node(NodeType.cell);
            break;
          default:
            break;
        }
      }
    }
    _streamController.add(_matrix);
  }

  int get rows => _matrix.length;
  int get cols => _matrix[0].length;

  Node get(int i, int j) => _matrix[i][j];

  void set(int i, int j, Node node) {
    _matrix[i][j] = node;
    _streamController.add(_matrix);
  }

  NodeType type(int i, int j) => _matrix[i][j].type;

  Either<Nothing, Point<int>> exists(NodeType nodeType) {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (_matrix[i][j].type == nodeType) return Right(Point(i, j));
      }
    }
    return Left(Nothing());
  }

  final _streamController = StreamController<List<List<Node>>>.broadcast();
  Stream<List<List<Node>>> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}

class MatrixNotifier extends StateNotifier<Matrix> {
  MatrixNotifier(Matrix state) : super(state);

  int get rows => state.rows;
  int get cols => state.cols;

  void set(int i, int j, Node node) {
    final newState = Matrix.deepCopy(state);
    newState.set(i, j, node);
    state = newState;
  }

  void clearPathfinding() {
    final newState = Matrix.deepCopy(state);
    newState.clearPathfinding();
    state = newState;
  }

  Matrix get matrix => state;

  Matrix deepCopy() => Matrix.deepCopy(state);

  List<List<Node>> get matrixElements => state._matrix;

  Node get(int i, int j) => state.get(i, j);

  NodeType type(int i, int j) => state.type(i, j);

  Either<Nothing, Point<int>> exists(NodeType nodeType) => state.exists(nodeType);
}

final matrixProvider = StateNotifierProvider.autoDispose<MatrixNotifier, Matrix>(
    (ref) => MatrixNotifier(Matrix(List.generate(15, (_) => List.generate(15, (_) => const Node(NodeType.cell))))));
