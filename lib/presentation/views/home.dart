import 'dart:math';

import 'package:algorithm_visualizer/algorithms/bfs.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MatrixCubit>().initMatrix(n: 19);
  }

  NodeType _selectedNodeType = NodeType.start; // todo: make this a single source of truth
  Offset _previousLocalPos = const Offset(-1000, -1000);

  void write(Offset localPos, DisplayMatrix matrix, double itemSize) {
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
            context.read<MatrixCubit>().setNode(row, col, _selectedNodeType);
          }
        },
        (point) {
          context.read<MatrixCubit>().setNode(point.x, point.y, NodeType.cell);
          context.read<MatrixCubit>().setNode(row, col, _selectedNodeType);
        },
      );
    } else if (_selectedNodeType == NodeType.end) {
      context.read<MatrixCubit>().nodeExists(NodeType.end).fold(
        (result) {
          if (result is Nothing) {
            context.read<MatrixCubit>().setNode(row, col, _selectedNodeType);
          }
        },
        (point) {
          context.read<MatrixCubit>().setNode(point.x, point.y, NodeType.cell);
          context.read<MatrixCubit>().setNode(row, col, _selectedNodeType);
        },
      );
    } else if (_selectedNodeType == NodeType.wall) {
      context.read<MatrixCubit>().nodeTypeAtPoint(row, col).fold(
          (result) => null, // Don't do anything if not result we expect
          (nodeType) => nodeType == NodeType.wall
              ? context.read<MatrixCubit>().setNode(row, col, NodeType.cell)
              : context.read<MatrixCubit>().setNode(row, col, _selectedNodeType));
    } else {
      context.read<MatrixCubit>().setNode(row, col, _selectedNodeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MatrixCubit>().resetMatrixAfterRunning();
          Point<int> start = context.read<MatrixCubit>().nodeExists(NodeType.start).fold(
                (l) => throw Exception("no start"),
                (r) => r,
              );
          Point<int> end = context.read<MatrixCubit>().nodeExists(NodeType.end).fold(
                (l) => throw Exception("no end"),
                (r) => r,
              );
          List<List<Node>> algorithmMatrixClone = (context.read<MatrixCubit>().state as DisplayMatrix).clone().matrix;
          context.read<MatrixCubit>().visualizeAlgorithm(
                dartz.Right(
                  Bfs().run(algorithmMatrixClone, start, end).path.fold((l) => throw Exception("no path"), (r) {
                    print(r.map((e) => e.updatedTo.toString()).toList());
                    return r;
                  }),
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
