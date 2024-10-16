import 'package:flutter/material.dart';
import 'package:quizapp_screen/bloc/screen_app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp_screen/presentation/category_screen.dart';
import 'package:quizapp_screen/presentation/countdown_screen.dart';
import 'package:quizapp_screen/presentation/loading_screen.dart';
import 'package:quizapp_screen/presentation/point_input_screen.dart';
import 'package:quizapp_screen/presentation/question_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          previous != current ||
          current is ScreenAppShowQuestion ||
          current is ScreenAppShowCountdown ||
          current is ScreenAppShowAnswer,
      bloc: BlocProvider.of<ScreenAppBloc>(context),
      builder: (BuildContext context, state) {
        if (state is ScreenAppInitial) {
          return const LoadingScreen();
        } else if (state is ScreenAppConnecting) {
          return const LoadingScreen();
        } else if (state is ScreenAppWaitingForData) {
          return const LoadingScreen();
        } else if (state is ScreenAppShowCategory) {
          return CategoryScreen(
            key: ValueKey(state.selectedCategory),
            categories: state.categories,
            selectedCategory: state.selectedCategory,
          );
        } else if (state is ScreenAppShowQuestion) {
          return QuestionScreen(
            question: state.question,
            category: state.category,
            jugendfeuerwehr: state.jugendfeuerwehr,
          );
        } else if (state is ScreenAppShowCountdown) {
          return CountdownScreen(
            question: state.question,
            category: state.category,
            countdown: state.countdown,
          );
        } else if (state is ScreenAppShowAnswer) {
          return QuestionScreen(
            question: state.question,
            category: state.category,
            jugendfeuerwehr: state.jugendfeuerwehr,
            answer: state.answer,
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
