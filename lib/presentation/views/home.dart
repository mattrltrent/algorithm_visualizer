import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:algorithm_visualizer/presentation/widgets/appbar.dart';
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
                const TopAppbar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final itemSize = constraints.maxWidth / state.matrix[0].length;
                            return Listener(
                              onPointerDown: (details) {
                                final row =
                                    (details.localPosition.dy / itemSize).floor().clamp(0, state.matrix.length - 1);
                                final col =
                                    (details.localPosition.dx / itemSize).floor().clamp(0, state.matrix[0].length - 1);
                                context.read<MatrixCubit>().setNode(row, col, const Node(NodeType.wall));
                              },
                              onPointerMove: (details) {
                                final row =
                                    (details.localPosition.dy / itemSize).floor().clamp(0, state.matrix.length - 1);
                                final col =
                                    (details.localPosition.dx / itemSize).floor().clamp(0, state.matrix[0].length - 1);
                                context.read<MatrixCubit>().setNode(row, col, const Node(NodeType.wall));
                              },
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
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: node.type == NodeType.unvisited
                                            ? Colors.white
                                            : node.type == NodeType.wall
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.green,
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
                                      width: itemSize,
                                      height: itemSize,
                                    );
                                  },
                                  childCount: state.matrix.length * state.matrix[0].length,
                                ),
                              ),
                            );
                          },
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
