import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../entities/nodes.dart';

part 'matrix_state.dart';

class MatrixCubit extends Cubit<MatrixState> {
  static const int MAX_ITEM_SIZE = 40;
  static const int MIN_ITEM_SIZE = 10;
  MatrixCubit() : super(LoadingMatrix());

  void initMatrix(Size size) {
    final screenWidth = size.width;
    final screenHeight = size.height;

    // calculate the maximum number of rows and columns for the matrix based on the screen size
    final maxCols = (screenWidth / MIN_ITEM_SIZE).floor();
    final maxRows = (screenHeight / MIN_ITEM_SIZE).floor();
    final minCols = (screenWidth / MAX_ITEM_SIZE).ceil();
    final minRows = (screenHeight / MAX_ITEM_SIZE).ceil();

    // start with the maximum number of columns and decrease until the matrix fits on the screen
    int cols = maxCols;
    int rows = maxRows;

    // while (cols >= minCols && rows >= minRows) {
    //   final itemSize = screenWidth / cols;
    //   final numRows = (screenHeight / itemSize).floor();

    //   if (numRows * cols <= maxCols * maxRows) {
    //     rows = numRows;
    //     break;
    //   }

    //   cols -= 1;
    // }

    // create the matrix with the calculated dimensions
    final matrix = List.generate(rows, (_) => List.generate(cols, (_) => Node(NodeType.blank)));

    // print(matrix);
    // initialize the matrix size with the calculated dimensions
    emit(DisplayMatrix(matrix: matrix));
  }
}
