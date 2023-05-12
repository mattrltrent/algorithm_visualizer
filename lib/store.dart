import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class Matrix {
  final List<List<int>> _matrix;

  Matrix(this._matrix);

  factory Matrix.copy(Matrix other) {
    final matrixCopy = List.generate(
      other.rows,
      (i) => List.generate(other.cols, (j) => other.get(i, j)),
    );
    return Matrix(matrixCopy);
  }

  int get rows => _matrix.length;
  int get cols => _matrix[0].length;

  int get(int i, int j) => _matrix[i][j];

  void set(int i, int j, int value) {
    _matrix[i][j] = value;
    _streamController.add(_matrix);
  }

  final _streamController = StreamController<List<List<int>>>.broadcast();
  Stream<List<List<int>>> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}

final intMatrixProvider = StateNotifierProvider.autoDispose<MatrixNotifier, Matrix>(
    (ref) => MatrixNotifier(Matrix(List.generate(10, (_) => List.generate(10, (_) => 0)))));

class MatrixNotifier extends StateNotifier<Matrix> {
  MatrixNotifier(Matrix state) : super(state);

  void set(int i, int j, int value) {
    final newState = Matrix.copy(state);
    newState.set(i, j, value);
    state = newState;
  }
}
