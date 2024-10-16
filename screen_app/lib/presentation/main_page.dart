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
          return LoadingScreen();
        } else if (state is ScreenAppConnecting) {
          return LoadingScreen();
        } else if (state is ScreenAppWaitingForData) {
          return LoadingScreen();
        } else if (state is ScreenAppShowCategory) {
          return CategoryScreen(
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
          return QuestionScreen(
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
          return Scaffold();
        } else if (state is ScreenAppShowPointInput) {
          return PointInputScreen();
        }
        return Scaffold();
      },
    );
  }
}
