part of 'matrix_cubit.dart';

abstract class MatrixState extends Equatable {
  const MatrixState();

  @override
  List<Object?> get props => [];
}

class LoadingMatrix extends MatrixState {}

class DisplayMatrix extends MatrixState {
  final List<List<Node>> matrix;

  const DisplayMatrix({required this.matrix});

  @override
  List<Object?> get props => [matrix];
}
