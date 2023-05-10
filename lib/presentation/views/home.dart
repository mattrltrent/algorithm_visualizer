import 'package:algorithm_visualizer/core/results.dart';
import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:algorithm_visualizer/presentation/widgets/editor_appbar.dart';
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
    context.read<MatrixCubit>().initMatrix();
  }

  NodeType _selectedNodeType = NodeType.cell;

  void write(Offset localPos, DisplayMatrix matrix, double itemSize) {
    final row = (localPos.dy / itemSize).floor().clamp(0, matrix.matrix.length - 1);
    final col = (localPos.dx / itemSize).floor().clamp(0, matrix.matrix[0].length - 1);
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
    }

    context.read<MatrixCubit>().setNode(row, col, Node(_selectedNodeType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            border: Border.all(color: Colors.black),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final itemSize = constraints.maxWidth / state.matrix[0].length;
                              return Listener(
                                  onPointerDown: (details) => write(details.localPosition, state, itemSize),
                                  onPointerMove: (details) => write(details.localPosition, state, itemSize),
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
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: node.type.color,
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.blue.withOpacity(0.5),
                                                width: row == 0 ? 0.5 : 0,
                                              ),
                                              left: BorderSide(
                                                color: Colors.blue.withOpacity(0.5),
                                                width: col == 0 ? 0.5 : 0,
                                              ),
                                              right: BorderSide(
                                                color: Colors.blue.withOpacity(0.5),
                                                width: col == state.matrix[0].length - 1 ? 0.5 : 0,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.blue.withOpacity(0.5),
                                                width: row == state.matrix.length - 1 ? 0.5 : 0,
                                              ),
                                            ),
                                          ),
                                        );
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
