enum NodeType {
  blank,
  visited,
  active,
  start,
  end,
}

class Node {
  final NodeType type;
  Node(this.type);
}
