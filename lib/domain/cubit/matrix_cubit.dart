import 'dart:async';
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

  void initMatrix({int n = 25}) {
    final matrix = List.generate(n, (_) => List.generate(n, (_) => const Node(NodeType.cell)));
    emit(DisplayMatrix(matrix: matrix, updateFlag: false, isVisualizing: false));
  }

  Either<Success, Failure> setNode(int i, int j, Node node) {
    if (state is DisplayMatrix) {
      List<List<Node>> updatedMatrix = List<List<Node>>.from((state as DisplayMatrix).matrix);
      updatedMatrix[i][j] = node;
      emit(DisplayMatrix(
          matrix: updatedMatrix,
          updateFlag: !(state as DisplayMatrix).updateFlag,
          isVisualizing: (state as DisplayMatrix).isVisualizing));
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

  Future<Result> visualizeAlgorithm(List<MatrixUpdate> path, {int blockPlacingMultiplier = 1}) async {
    final currentState = state as DisplayMatrix;
    if (currentState.isVisualizing) return AlreadyVisualizing();
    final newState = currentState.copyWith(isVisualizing: true);
    emit(newState);
    int idx = 0;
    await Future.delayed(const Duration(milliseconds: 250)); // give time for cleared board to be seen
    List paths = [];
    for (final update in path) {
      if (update.updatedTo == NodeType.path) {
        paths.add(update);
      } else {
        setNode(update.row, update.col,
            Node(update.updatedTo, delay: Duration(milliseconds: blockPlacingMultiplier * idx)));
        idx++;
      }
    }
    await Future.delayed(Duration(milliseconds: blockPlacingMultiplier * idx));
    idx = 0;
    for (final update in paths) {
      setNode(
          update.row, update.col, Node(update.updatedTo, delay: Duration(milliseconds: blockPlacingMultiplier * idx)));
      idx++;
    }
    // add all paths
    emit(currentState.copyWith(isVisualizing: false));
    return GeneralSuccess();
  }

  Result resetMatrixAfterRunning() {
    if (state is DisplayMatrix) {
      final matrix = (state as DisplayMatrix).matrix;
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[0].length; j++) {
          if (matrix[i][j].type == NodeType.visited || matrix[i][j].type == NodeType.path) {
            setNode(i, j, const Node(NodeType.cell));
          }
        }
      }
      emit((state as DisplayMatrix)); // todo: needed?
      return GeneralSuccess();
    } else {
      return BadState();
    }
  }
}
