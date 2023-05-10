import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MatrixCubit, MatrixState>(
        builder: (context, state) {
          if (state is LoadingMatrix) {
            return Center(
              child: GestureDetector(
                onTap: () => context.read<MatrixCubit>().initMatrix(MediaQuery.of(context).size),
                child: const CupertinoActivityIndicator(),
              ),
            );
          } else if (state is DisplayMatrix) {
            print("DISPLAY MATRIX");
            return LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.matrix.length * state.matrix[0].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: state.matrix[0].length,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ state.matrix[0].length;
                    final col = index % state.matrix[0].length;
                    final node = state.matrix[row][col];

                    final nodeHeight = constraints.maxHeight / state.matrix.length;
                    final nodeWidth = constraints.maxWidth / state.matrix[0].length;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white),
                      ),
                      height: nodeHeight,
                      width: nodeWidth,
                      child: Text(node.type.toString()),
                    );
                  },
                );
              },
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
