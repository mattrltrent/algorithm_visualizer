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

  const UserPrefs({required this.speed, required this.algorithm, required this.editorNodeType});

  @override
  List<Object> get props => [speed, algorithm, editorNodeType];

  UserPrefs copyWith({
    Speed? speed,
    Algorithm? algorithm,
    NodeType? editorNodeType,
  }) {
    return UserPrefs(
      speed: speed ?? this.speed,
      algorithm: algorithm ?? this.algorithm,
      editorNodeType: editorNodeType ?? this.editorNodeType,
    );
  }
}
