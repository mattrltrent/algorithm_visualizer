import 'dart:async';
import 'dart:math';

import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/domain/entities/node.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import 'algorithms/bfs.dart';

class Matrix {
  List<List<Node>> _matrix;
  bool _isVisualizing;
  UniqueKey _key;

  Matrix(this._matrix, this._key, {bool isVisualizing = false}) : _isVisualizing = isVisualizing;

  List<List<Node>> get matrixElements => _matrix;

  bool get isVisualizing => _isVisualizing;

  UniqueKey get key => _key;

  factory Matrix.deepCopy(Matrix other) {
    final matrixCopy = List.generate(
      other.rows,
      (i) => List.generate(other.cols, (j) => other.get(i, j).deepCopy()),
    );
    return Matrix(matrixCopy, other.key, isVisualizing: other.isVisualizing);
  }

  void clearPathfinding() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        switch (_matrix[i][j].type) {
          case NodeType.visited:
          case NodeType.path:
            _matrix[i][j] = Node(NodeType.cell, _key);
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

  void setVisualizing(bool isVisualizing) {
    _isVisualizing = isVisualizing;
    _streamController.add(_matrix);
  }

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

  void dispose() => _streamController.close();

  void genNewKey() {
    _key = UniqueKey();
    _streamController.add(_matrix);
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

  UniqueKey get key => state.key;

  void genNewKey() {
    final newState = Matrix.deepCopy(state);
    newState.genNewKey();
    state = newState;
  }

  bool get isVisualizing => state.isVisualizing;

  void setVisualizing(bool isVisualizing) {
    final newState = Matrix.deepCopy(state);
    newState._isVisualizing = isVisualizing;
    state = newState;
  }

  void initMap({int n = 20}) {
    n = 20;
    Random random = Random();
    bool invalidMaze = true;
    List<List<Node>> matrix = List.generate(
      n,
      (_) => List.generate(
        n,
        (_) {
          if ((random.nextInt(3)) == 1) {
            return Node(NodeType.wall, key);
          } else {
            return Node(NodeType.cell, key);
          }
        },
      ),
    );
    while (invalidMaze) {
      matrix = List.generate(
          n,
          (_) => List.generate(n, (_) {
                if ((random.nextInt(3)) == 1) {
                  return Node(NodeType.wall, key);
                } else {
                  return Node(NodeType.cell, key);
                }
              }));
      Point<int> start = Point(random.nextInt(n), random.nextInt(n));
      Point<int> end = Point(random.nextInt(n), random.nextInt(n));

      matrix[start.x][start.y] = Node(NodeType.start, key);
      matrix[end.x][end.y] = Node(NodeType.end, key);
      if (sqrt(pow(start.x - end.x, 2) + pow(start.y - end.y, 2)) < n / 1.2) {
        continue;
      }
      if (Bfs().run(matrix.map((row) => row.map((node) => node.deepCopy()).toList()).toList(), start, end).pathFound) {
        invalidMaze = false;
      }
    }
    // emit(DisplayMatrix(matrix: matrix, updateFlag: false, isVisualizing: false));
    final newState = Matrix.deepCopy(state);
    newState._matrix = matrix;
    state = newState;
  }

  Matrix deepCopy() => Matrix.deepCopy(state);

  List<List<Node>> get matrixElements => state._matrix;

  Node get(int i, int j) => state.get(i, j);

  NodeType type(int i, int j) => state.type(i, j);

  Either<Nothing, Point<int>> exists(NodeType nodeType) => state.exists(nodeType);
}

final matrixProvider = StateNotifierProvider.autoDispose<MatrixNotifier, Matrix>((ref) {
  UniqueKey key = UniqueKey();
  return MatrixNotifier(Matrix(List.generate(15, (_) => List.generate(15, (_) => Node(NodeType.cell, key))), key));
});
