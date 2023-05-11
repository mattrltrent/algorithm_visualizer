import 'dart:math';

import 'package:algorithm_visualizer/algorithms/bfs.dart';
import 'package:algorithm_visualizer/algorithms/dfs.dart';
import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:algorithm_visualizer/presentation/widgets/editor_appbar.dart';
import 'package:algorithm_visualizer/presentation/widgets/node_grid_item.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/node.dart';
import '../widgets/alert_banner.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MatrixCubit>().initMatrix();
  }

  NodeType _selectedNodeType = NodeType.start; // todo: make this a single source of truth
  Offset _previousLocalPos = const Offset(-1000, -1000);

  void write(Offset localPos, DisplayMatrix matrix, double itemSize) {
    // Don't run if the algorithm is currently visualizing
    if (matrix.isVisualizing) return;

    // Clear old visited/path nodes.
    context.read<MatrixCubit>().resetMatrixAfterRunning();

    final row = (localPos.dy / itemSize).floor().clamp(0, matrix.matrix.length - 1);
    final col = (localPos.dx / itemSize).floor().clamp(0, matrix.matrix[0].length - 1);
    final currentLocalPos = Offset(row.toDouble(), col.toDouble());

    // Don't call this function multiple times per grid item
    if (_previousLocalPos == currentLocalPos) return;
    _previousLocalPos = currentLocalPos;

    // At most 1 start/finish node should exist at a time
    if (_selectedNodeType == NodeType.start) {
      context.read<MatrixCubit>().nodeExists(NodeType.start).fold(
        (result) {
          if (result is Nothing) {
            context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
          }
        },
        (point) {
          context.read<MatrixCubit>().setNode(point.x, point.y, const Node(NodeType.cell));
          context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
        },
      );
    } else if (_selectedNodeType == NodeType.end) {
      context.read<MatrixCubit>().nodeExists(NodeType.end).fold(
        (result) {
          if (result is Nothing) {
            context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
          }
        },
        (point) {
          context.read<MatrixCubit>().setNode(point.x, point.y, const Node(NodeType.cell));
          context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
        },
      );
    } else if (_selectedNodeType == NodeType.wall) {
      context.read<MatrixCubit>().nodeTypeAtPoint(row, col).fold(
          (result) => null, // Don't do anything if not result we expect
          (nodeType) => nodeType == NodeType.wall
              ? context.read<MatrixCubit>().setNode(row, col, const Node(NodeType.cell))
              : context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType)));
    } else {
      context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MatrixState state = context.read<MatrixCubit>().state;
          if (state is! DisplayMatrix || state.isVisualizing) return;
          context.read<MatrixCubit>().resetMatrixAfterRunning();
          context.read<MatrixCubit>().nodeExists(NodeType.start).fold(
                (result) => showAlert(context, "No start point found.", true),
                (startPoint) => context.read<MatrixCubit>().nodeExists(NodeType.end).fold(
                  (result) => showAlert(context, "No end point found.", true),
                  (endPoint) {
                    List<List<Node>> algorithmMatrixClone =
                        (context.read<MatrixCubit>().state as DisplayMatrix).clone().matrix;
                    AlgorithmStats stats = Bfs().run(algorithmMatrixClone, startPoint, endPoint);
                    if (stats.pathFound) {
                      showAlert(context, "Path found in ${stats.timeTakenMicroSec.toString()} μs.", false);
                    } else {
                      showAlert(context, "No path found in ${stats.timeTakenMicroSec.toString()} μs.", true);
                    }
                    context.read<MatrixCubit>().visualizeAlgorithm(stats.path);
                  },
                ),
              );
        },
      ),
      body: BlocBuilder<MatrixCubit, MatrixState>(
        builder: (context, state) {
          if (state is LoadingMatrix) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is DisplayMatrix) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EditorAppBar(onNodeSelected: (nodeType) => setState(() => _selectedNodeType = nodeType)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final itemSize = constraints.maxWidth / state.matrix[0].length;
                              return Listener(
                                  onPointerDown: (details) => write(details.localPosition, state, itemSize),
                                  onPointerMove: (details) => write(details.localPosition, state, itemSize),
                                  onPointerUp: (_) => setState(() => _previousLocalPos =
                                      const Offset(-1000, -1000)), // Rest local position if user lifts finger/cursor
                                  child: GridView.custom(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: state.matrix[0].length,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                    ),
                                    childrenDelegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final row = index ~/ state.matrix[0].length;
                                        final col = index % state.matrix[0].length;
                                        final node = state.matrix[row][col];
                                        return NodeGridItem(matrix: state.matrix, node: node, row: row, col: col);
                                      },
                                      childCount: state.matrix.length * state.matrix[0].length,
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
