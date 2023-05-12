import 'package:algorithm_visualizer/algorithms/bfs.dart';
import 'package:algorithm_visualizer/domain/entities/algorithm.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../entities/node.dart';
import '../entities/speed.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit()
      : super(
          UserPrefs(
            algorithm: Bfs(),
            speed: Speed.slow,
            editorNodeType: NodeType.start,
            nSizeMatrix: 5,
          ),
        ); // defaults

  void setSpeed(Speed speed) => emit((state as UserPrefs).copyWith(speed: speed));

  void setAlgorithm(Algorithm algorithm) => emit((state as UserPrefs).copyWith(algorithm: algorithm));

  void setEditorNodeType(NodeType nodeType) => emit((state as UserPrefs).copyWith(editorNodeType: nodeType));

  void setNSizeMatrix(int n) => emit((state as UserPrefs).copyWith(nSizeMatrix: n));
}
