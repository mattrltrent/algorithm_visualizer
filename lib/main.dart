import 'package:algorithm_visualizer/domain/cubit/matrix_cubit.dart';
import 'package:algorithm_visualizer/domain/cubit/user_cubit.dart';
import 'package:algorithm_visualizer/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dep_inj.dart';

void main() async => await init().then((_) => runApp(const ProviderScope(child: MyApp())));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => sl<MatrixCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<UserCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Algorithm Visualizer',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeView(),
      ),
    );
  }
}
