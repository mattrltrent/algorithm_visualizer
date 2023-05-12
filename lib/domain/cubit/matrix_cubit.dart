import 'dart:async';
import 'dart:math';

import 'package:algorithm_visualizer/algorithms/bfs.dart';
import 'package:algorithm_visualizer/algorithms/dfs.dart';
import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/domain/cubit/user_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../entities/algorithm.dart';
import '../entities/node.dart';

part 'matrix_state.dart';

class MatrixCubit extends Cubit<MatrixState> {
  MatrixCubit() : super(LoadingMatrix());

  void initMatrix({int n = 10}) {
    final matrix = List.generate(n, (_) => List.generate(n, (_) => const Node(NodeType.cell)));
    emit(DisplayMatrix(matrix: matrix, updateFlag: false, isVisualizing: false));
  }

  void initMap({int n = 10}) {
    Random random = Random();
    bool invalidMaze = true;
    List<List<Node>> matrix = List.generate(
      n,
      (_) => List.generate(
        n,
        (_) {
          if ((random.nextInt(3)) == 1) {
            return const Node(NodeType.wall);
          } else {
            return const Node(NodeType.cell);
          }
        },
      ),
    );
    while (invalidMaze) {
      matrix = List.generate(
          n,
          (_) => List.generate(n, (_) {
                if ((random.nextInt(3)) == 1) {
                  return const Node(NodeType.wall);
                } else {
                  return const Node(NodeType.cell);
                }
              }));
      Point<int> start = Point(random.nextInt(n), random.nextInt(n));
      Point<int> end = Point(random.nextInt(n), random.nextInt(n));

      matrix[start.x][start.y] = const Node(NodeType.start);
      matrix[end.x][end.y] = const Node(NodeType.end);
      if (sqrt(pow(start.x - end.x, 2) + pow(start.y - end.y, 2)) < n / 1.2) {
        continue;
      }
      if (Bfs().run(matrix.map((row) => row.map((node) => node.deepCopy()).toList()).toList(), start, end).pathFound) {
        invalidMaze = false;
      }
    }
    emit(DisplayMatrix(matrix: matrix, updateFlag: false, isVisualizing: false));
  }

  Either<Success, Failure> setNode(int i, int j, Node node, bool isVisualizing) {
    if (state is DisplayMatrix) {
      List<List<Node>> updatedMatrix = List<List<Node>>.from((state as DisplayMatrix).matrix);
      updatedMatrix[i][j] = node;
      emit(
        DisplayMatrix(
          matrix: updatedMatrix,
          updateFlag: !(state as DisplayMatrix).updateFlag,
          isVisualizing: isVisualizing,
        ),
      );
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
    // resetMatrixAfterRunning();
    // emit((state as DisplayMatrix));
    final currentState = state as DisplayMatrix;
    if (currentState.isVisualizing) return AlreadyVisualizing();
    final newState = currentState.copyWith(isVisualizing: true).clone();
    emit(newState);
    print("starting...");
    // await Future.delayed(const Duration(milliseconds: 250)); // give time for cleared board to be seen

    for (final update in path) {
      if (update.updatedTo == NodeType.path) {
        setNode(update.row, update.col, Node(update.updatedTo), true);
      } else {
        setNode(update.row, update.col, Node(update.updatedTo), true);
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }

    emit((state as DisplayMatrix).copyWith(isVisualizing: false).clone());
    print("DONE");
    return GeneralSuccess();
  }

  Result resetMatrixAfterRunning() {
    print("RESetting....");
    if (state is DisplayMatrix && !(state as DisplayMatrix).isVisualizing) {
      final matrix = (state as DisplayMatrix).matrix;
      for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[0].length; j++) {
          if (matrix[i][j].type == NodeType.visited || matrix[i][j].type == NodeType.path) {
            // setNode(i, j, const Node(NodeType.cell));
          }
        }
      }
      print("end of reset matrix before overall emit");
      emit((state as DisplayMatrix)
          .copyWith(updateFlag: !(state as DisplayMatrix).updateFlag, isVisualizing: false)); // todo: needed?
      return GeneralSuccess();
    } else {
      return BadState();
    }
  }

  void printBoard() {
    print("-------");
    if (state is DisplayMatrix) {
      final matrix = (state as DisplayMatrix).matrix;
      for (var i = 0; i < matrix.length; i++) {
        String row = "";
        for (var j = 0; j < matrix[0].length; j++) {
          row += matrix[i][j].type.toString() + ",";
        }
        print("\n");
        print(row);
      }
    }
    print("-------");
  }
}
