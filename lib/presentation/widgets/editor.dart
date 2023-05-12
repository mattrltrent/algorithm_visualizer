import 'package:algorithm_visualizer/algorithms/bfs.dart';
import 'package:algorithm_visualizer/algorithms/dfs.dart';
import 'package:algorithm_visualizer/core/styles/typography.dart';
import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:algorithm_visualizer/domain/entities/speed.dart';
import 'package:algorithm_visualizer/presentation/widgets/alert_banner.dart';
import 'package:algorithm_visualizer/presentation/widgets/node_pallet.dart';
import 'package:algorithm_visualizer/presentation/widgets/primary_button.dart';
import 'package:algorithm_visualizer/presentation/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/cubit/matrix_cubit.dart';
import '../../domain/cubit/user_cubit.dart';
import 'dropdown.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key, required this.runAlgorithm}) : super(key: key);

  final VoidCallback runAlgorithm;

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  List<Algorithm> algorithms = [Bfs(), Dfs()];
  List<Speed> speed = [Speed.slow, Speed.medium, Speed.fast];
  List<int> nSizeMatrix = [5, 10, 20, 30, 40];

  void _launchUrl(String url) async {
    try {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      showAlert(context, "Unable to open link.", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(51, 60, 131, 1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Pathfinding Visualizer — β",
                style: font1.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 20),
              TouchableOpacity(
                onTap: () => _launchUrl("https://github.com/mattrltrent/algorithm_visualizer"),
                child: const SizedBox(
                  height: 40,
                  child: Image(
                    image: AssetImage('assets/github.png'),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          NodePalette(onNodeSelected: (nodeType) => context.read<UserCubit>().setEditorNodeType(nodeType)),
          const SizedBox(height: 20),
          Expanded(
              child: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              PrimaryButton(text: "Run algorithm", onTap: () => widget.runAlgorithm()),
              PrimaryButton(
                text: "Clear path",
                onTap: () => context.read<MatrixCubit>().resetMatrixAfterRunning(),
              ),
              PrimaryButton(
                  text: "Randomize map",
                  onTap: () {
                    int matrixSize = (context.read<UserCubit>().state as UserPrefs).nSizeMatrix;
                    context.read<MatrixCubit>().initMap(n: matrixSize);
                  }),
              PrimaryButton(text: "PRINT MATRIX", onTap: () => context.read<MatrixCubit>().printBoard()),
              AppleDropdown(
                onSelect: (idx) => context.read<UserCubit>().setAlgorithm(algorithms[idx]),
                selectedOption: (context.watch<UserCubit>().state as UserPrefs).algorithm.name(),
                options: algorithms.map((e) => e.name()).toList(),
              ),
              AppleDropdown(
                onSelect: (idx) => context.read<UserCubit>().setSpeed(speed[idx]),
                selectedOption: (context.watch<UserCubit>().state as UserPrefs).speed.name,
                options: speed.map((e) => e.name).toList(),
              ),
              AppleDropdown(
                onSelect: (idx) {
                  context.read<UserCubit>().setNSizeMatrix(nSizeMatrix[idx]);
                  context.read<MatrixCubit>().initMatrix(n: (context.read<UserCubit>().state as UserPrefs).nSizeMatrix);
                },
                selectedOption: "n: ${(context.watch<UserCubit>().state as UserPrefs).nSizeMatrix.toString()}",
                options: nSizeMatrix.map((e) => e.toString()).toList(),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
