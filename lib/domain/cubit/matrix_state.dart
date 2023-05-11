part of 'matrix_cubit.dart';

abstract class MatrixState extends Equatable {
  const MatrixState();

  @override
  List<Object?> get props => [];
}

class LoadingMatrix extends MatrixState {}

class DisplayMatrix extends MatrixState {
  final List<List<Node>> matrix;
  final bool updateFlag;

  const DisplayMatrix({required this.matrix, required this.updateFlag});

  DisplayMatrix clone() {
    final clonedMatrix = matrix.map((row) => row.map((node) => node.clone()).toList()).toList();
    return DisplayMatrix(matrix: clonedMatrix, updateFlag: !updateFlag);
  }

  @override
  List<Object?> get props => [matrix, updateFlag];
}
