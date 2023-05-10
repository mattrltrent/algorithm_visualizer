import 'package:equatable/equatable.dart';

enum NodeType {
  unvisited,
  visited,
  wall,
  start,
  end,
}

class Node extends Equatable {
  final NodeType? type;
  const Node(this.type);
  @override
  List<Object?> get props => [type];
}
