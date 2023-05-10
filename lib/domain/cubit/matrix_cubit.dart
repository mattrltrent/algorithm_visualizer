import 'dart:math';

import 'package:algorithm_visualizer/core/results.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../entities/node.dart';

part 'matrix_state.dart';

class MatrixCubit extends Cubit<MatrixState> {
  MatrixCubit() : super(LoadingMatrix());

  void initMatrix({int x = 30, int y = 35}) {
    final matrix = List.generate(y, (_) => List.generate(x, (_) => const Node(NodeType.unvisited)));
    emit(DisplayMatrix(matrix: matrix, updateFlag: false));
  }

  Either<Success, Failure> setNode(int i, int j, Node node) {
    if (state is DisplayMatrix) {
      List<List<Node>> updatedMatrix = List<List<Node>>.from((state as DisplayMatrix).matrix);
      updatedMatrix[i][j] = node;
      emit(DisplayMatrix(matrix: updatedMatrix, updateFlag: !(state as DisplayMatrix).updateFlag));
      return Left(GeneralSuccess());
    } else {
      return Right(NoneFailure());
    }
  }

  Either<Node, Failure> getNode(int i, int j) {
    if (state is DisplayMatrix) {
      return Left((state as DisplayMatrix).matrix[i][j]);
    } else {
      return Right(NoneFailure());
    }
  }
}
