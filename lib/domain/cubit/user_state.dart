part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserPrefs extends UserState {
  final Speed speed;
  final Algorithm algorithm;
  final NodeType editorNodeType;
  final int nSizeMatrix;

  const UserPrefs(
      {required this.speed, required this.algorithm, required this.editorNodeType, required this.nSizeMatrix});

  @override
  List<Object> get props => [speed, algorithm, editorNodeType, nSizeMatrix, nSizeMatrix];

  UserPrefs copyWith({
    Speed? speed,
    Algorithm? algorithm,
    NodeType? editorNodeType,
    int? nSizeMatrix,
  }) {
    return UserPrefs(
      nSizeMatrix: nSizeMatrix ?? this.nSizeMatrix,
      speed: speed ?? this.speed,
      algorithm: algorithm ?? this.algorithm,
      editorNodeType: editorNodeType ?? this.editorNodeType,
    );
  }
}
