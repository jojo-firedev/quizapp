import 'package:flutter/material.dart';
import 'package:quizapp_screen/bloc/screen_app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp_screen/presentation/category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quizapp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => ScreenAppBloc(),
          child: BlocBuilder(
            builder: (BuildContext context, state) {
              if (state is ScreenAppInitial) {
                return const Scaffold();
              }
              if (state is ScreenAppConnecting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is ScreenAppWaitingForData) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is ScreenAppShowCategory) {
                return const CategoryPage();
              }
              if (state is ScreenAppShowQuestion) {
                return const Scaffold();
              }
              if (state is ScreenAppShowCountdown) {
                return const Scaffold();
              }
              if (state is ScreenAppShowAnswer) {
                return const Scaffold();
              }
              if (state is ScreenAppShowScore) {
                return const Scaffold();
              }
              if (state is ScreenAppShowPointInput) {
                return const Scaffold();
              }
              return const Scaffold();
            },
          ),
        ));
  }
}
