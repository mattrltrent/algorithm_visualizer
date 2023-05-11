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
  final bool isVisualizing;

  const DisplayMatrix({
    required this.matrix,
    required this.updateFlag,
    required this.isVisualizing,
  });

  DisplayMatrix clone() {
    final clonedMatrix = matrix.map((row) => row.map((node) => node.clone()).toList()).toList();
    return DisplayMatrix(matrix: clonedMatrix, updateFlag: !updateFlag, isVisualizing: isVisualizing);
  }

  DisplayMatrix copyWith({
    List<List<Node>>? matrix,
    bool? updateFlag,
    bool? isVisualizing,
  }) {
    return DisplayMatrix(
      matrix: matrix ?? this.matrix,
      updateFlag: updateFlag ?? this.updateFlag,
      isVisualizing: isVisualizing ?? this.isVisualizing,
    );
  }

  @override
  List<Object?> get props => [matrix, updateFlag, isVisualizing];
}
