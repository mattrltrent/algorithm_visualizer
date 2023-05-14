import 'dart:async';

import 'package:algorithm_visualizer/algorithms/bfs.dart';
import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:algorithm_visualizer/domain/cubit/user_cubit.dart';
import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:algorithm_visualizer/presentation/widgets/editor.dart';
import 'package:algorithm_visualizer/presentation/widgets/node_grid_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/node.dart';
import '../../store.dart';
import '../widgets/alert_banner.dart';

Future<void> sleep(int durationMs) {
  final completer = Completer<void>();
  Timer(Duration(milliseconds: durationMs), completer.complete);
  return completer.future;
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int nSizeMatrix = (context.read<UserCubit>().state as UserPrefs).nSizeMatrix;
    context.read<MatrixCubit>().initMatrix(n: nSizeMatrix);
  }

  Offset _previousLocalPos = const Offset(-1000, -1000);

  void runAlgo(BuildContext context) async {
    // ref.read(matrixProvider).setVisualizing(true);
    if (ref.read(matrixProvider).isVisualizing) return;
    // ref.read(matrixProvider.notifier).genNewKey();
    print("running anway");
    ref.read(matrixProvider).setVisualizing(true);
    ref.read(matrixProvider.notifier).clearPathfinding();
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {});
    // UniqueKey currentKey = ref.read(matrixProvider).key;
    await ref.read(matrixProvider).exists(NodeType.start).fold(
          (_) async => showAlert(context, "No start point found.", true),
          (startPoint) async => ref
              .read(matrixProvider)
              .exists(NodeType.end)
              .fold((_) async => showAlert(context, "No end point found.", true), (endPoint) async {
            final stats =
                Bfs().clone().run(ref.read(matrixProvider.notifier).deepCopy().matrixElements, startPoint, endPoint);
            int pathLength = stats.path.where((e) => e.updatedTo == NodeType.path).toList().length;
            bool isSingular = stats.path.length - pathLength == 1;
            if (stats.pathFound) {
              showAlert(
                  context,
                  "$pathLength-long path found in ${stats.timeTakenMicroSec.toString()} μs. Checked ${stats.path.length - pathLength} ${isSingular ? "node" : "nodes"}.",
                  false);
            } else {
              showAlert(
                  context,
                  "No path found in ${stats.timeTakenMicroSec.toString()} μs. Checked ${stats.path.length - pathLength} ${isSingular ? "node" : "nodes"}.",
                  true);
            }
            //! Matt
            int iter = 0;
            int delayMultiplier = 100;
            final List<MatrixUpdate> solutionPath = [];
            ref.read(matrixProvider.notifier).genNewKey();
            UniqueKey currentKey = ref.read(matrixProvider).key;
            for (final node in stats.path) {
              if (node.updatedTo == NodeType.path) {
                solutionPath.add(node);
              } else {
                ref.read(matrixProvider).set(node.row, node.col,
                    Node(node.updatedTo, currentKey, delay: Duration(milliseconds: delayMultiplier * iter)));
                iter += 1;
              }
              setState(() {});
            }
            await Future.delayed(Duration(milliseconds: delayMultiplier * iter));
            iter = 0;
            for (final node in solutionPath) {
              ref.read(matrixProvider).set(node.row, node.col,
                  Node(node.updatedTo, currentKey, delay: Duration(milliseconds: delayMultiplier * iter)));
              iter += 1;
              setState(() {});
            }
            await Future.delayed(Duration(milliseconds: delayMultiplier * iter));
            ref.read(matrixProvider).setVisualizing(false);
          }),
        );
    ref.read(matrixProvider).setVisualizing(false);
  }

  void paintNode(Offset localPos, Matrix matrix, double itemSize) {
    final row = (localPos.dy / itemSize).floor().clamp(0, matrix.rows - 1);
    final col = (localPos.dx / itemSize).floor().clamp(0, matrix.cols - 1);
    final currentLocalPos = Offset(row.toDouble(), col.toDouble());

    UniqueKey currentKey = ref.read(matrixProvider).key;

    if (_previousLocalPos == currentLocalPos) return;
    _previousLocalPos = currentLocalPos;

    NodeType selectedNodeType = (context.read<UserCubit>().state as UserPrefs).editorNodeType;
    switch (selectedNodeType) {
      case NodeType.start:
      case NodeType.end:
        ref.read(matrixProvider).exists(selectedNodeType).fold(
          (_) => ref.read(matrixProvider.notifier).set(row, col, Node(selectedNodeType, currentKey)),
          (point) {
            ref.read(matrixProvider.notifier).set(point.x, point.y, Node(NodeType.cell, currentKey));
            ref.read(matrixProvider.notifier).set(row, col, Node(selectedNodeType, currentKey));
          },
        );
        break;
      case NodeType.wall:
        ref.read(matrixProvider).type(row, col) == NodeType.wall
            ? ref.read(matrixProvider.notifier).set(row, col, Node(NodeType.cell, currentKey))
            : ref.read(matrixProvider.notifier).set(row, col, Node(selectedNodeType, currentKey));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Editor(
                runAlgorithm: () => runAlgo(context),
              ),
            ),
          ),
          Consumer(
            builder: (context, WidgetRef ref, _) {
              final matrix = ref.watch(matrixProvider);
              return Expanded(
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
                            final itemSize = constraints.maxWidth / matrix.cols;
                            return Listener(
                                onPointerDown: (details) => paintNode(details.localPosition, matrix, itemSize),
                                onPointerMove: (details) => paintNode(details.localPosition, matrix, itemSize),
                                onPointerUp: (_) => setState(() => _previousLocalPos = const Offset(-1000, -1000)),
                                child: GridView.custom(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: matrix.cols,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                  ),
                                  childrenDelegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final row = index ~/ matrix.cols;
                                      final col = index % matrix.cols;
                                      final node = matrix.get(row, col);
                                      return NodeGridItem(node: node, row: row, col: col);
                                    },
                                    childCount: matrix.rows * matrix.cols,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
