import 'package:flutter/material.dart';
import 'package:quizapp_screen/bloc/screen_app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp_screen/presentation/category_screen.dart';
import 'package:quizapp_screen/presentation/loading_screen.dart';
import 'package:quizapp_screen/presentation/point_input_screen.dart';
import 'package:quizapp_screen/presentation/question_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ScreenAppBloc>(context),
      builder: (BuildContext context, state) {
        if (state is ScreenAppInitial) {
          return const LoadingScreen();
        } else if (state is ScreenAppConnecting) {
          return const LoadingScreen();
        } else if (state is ScreenAppWaitingForData) {
          return const LoadingScreen();
        } else if (state is ScreenAppShowCategory) {
          return const CategoryScreen(
            categories: {
              'Kategorie 1': true,
              'Kategorie 2': true,
              'Kategorie 3': false,
              'Kategorie 4': false,
              'Kategorie 5': false,
              'Kategorie 6': false,
              'Kategorie 7': false,
              'Kategorie 8': false,
              'Kategorie 9': false,
              'Kategorie 10': false,
            },
            selectedCategory: 'Kategorie 3',
          );
        } else if (state is ScreenAppShowQuestion) {
          return const QuestionScreen(
            question: 'Frage',
            category: 'Kategorie',
            jugendfeuerwehr: 'Jugendfeuerwehr',
          );
        } else if (state is ScreenAppShowCountdown) {
          return const QuestionScreen(
            question: 'Frage',
            category: 'Kategorie',
            jugendfeuerwehr: 'Jugendfeuerwehr',
            countdown: 10,
          );
        } else if (state is ScreenAppShowAnswer) {
          return const QuestionScreen(
            question: 'Frage',
            category: 'Kategorie',
            jugendfeuerwehr: 'Jugendfeuerwehr',
            answer: 'Antwort',
          );
        } else if (state is ScreenAppShowScore) {
          return const Scaffold();
        } else if (state is ScreenAppShowPointInput) {
          return const PointInputScreen();
        }
        return const Scaffold();
      },
    );
  }
}
