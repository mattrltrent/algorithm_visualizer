import 'dart:math';

import 'package:algorithm_visualizer/core/results.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../entities/algorithm.dart';
import '../entities/node.dart';

part 'matrix_state.dart';

class MatrixCubit extends Cubit<MatrixState> {
  MatrixCubit() : super(LoadingMatrix());

  void initMatrix({int x = 10, int y = 10}) {
    final matrix = List.generate(y, (_) => List.generate(x, (_) => const Node(NodeType.cell)));
    emit(DisplayMatrix(matrix: matrix, updateFlag: false));
  }

  Either<Success, Failure> setNode(int i, int j, NodeType nodeType) {
    if (state is DisplayMatrix) {
      List<List<Node>> updatedMatrix = List<List<Node>>.from((state as DisplayMatrix).matrix);
      updatedMatrix[i][j] = Node(nodeType);
      emit(DisplayMatrix(matrix: updatedMatrix, updateFlag: !(state as DisplayMatrix).updateFlag));
      return Left(GeneralSuccess());
    } else {
      return Right(BadState());
    }
  }

  Either<Node, Result> getNode(int i, int j) {
    if (state is DisplayMatrix) {
      return Left((state as DisplayMatrix).matrix[i][j]);
    } else {
      return Right(Nothing());
    }
  }

  Either<Result, Point<int>> nodeExists(NodeType node) {
    if (state is DisplayMatrix) {
      final matrix = (state as DisplayMatrix).matrix;
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[0].length; j++) {
          if (matrix[i][j].type == node) {
            return Right(Point(i, j));
          }
        }
      }
      return Left(Nothing());
    } else {
      return Left(BadState());
    }
  }

  Either<Result, NodeType> nodeTypeAtPoint(int i, int j) {
    if (state is DisplayMatrix) {
      final matrix = (state as DisplayMatrix).matrix;
      return Right(matrix[i][j].type);
    } else {
      return Left(BadState());
    }
  }

  Future<Result> visualizeAlgorithm(Either<NoPath, List<MatrixUpdate>> path,
      {Duration blockPlacingDelay = const Duration(milliseconds: 15)}) async {
    if (state is DisplayMatrix) {
      return path.fold(
        (noPath) => NoPath(), // do nothing, as there's no path
        (matrixUpdates) async {
          for (final update in matrixUpdates) {
            await Future.delayed(blockPlacingDelay).then((value) => setNode(update.row, update.col, update.updatedTo));
          }
          return PathFound();
        },
      );
    } else {
      return BadState();
    }
  }
}
