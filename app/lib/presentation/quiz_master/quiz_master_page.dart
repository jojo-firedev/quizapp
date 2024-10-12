import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';
import 'package:quizapp/presentation/quiz_master/components/pages/categories_page.dart';
import 'package:quizapp/presentation/quiz_master/components/pages/points_page.dart';
import 'package:quizapp/presentation/quiz_master/components/pages/question_page.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class QuizMasterPage extends StatefulWidget {
  const QuizMasterPage({super.key});

  @override
  State<QuizMasterPage> createState() => _QuizMasterPageState();
}

class _QuizMasterPageState extends State<QuizMasterPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Global.connectionMode = ConnectionMode.game;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizMasterBloc()..add(LoadPage()),
      child: BlocBuilder<QuizMasterBloc, QuizMasterState>(
        builder: (context, state) {
          if (state is QuizMasterInitial) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is QuizMasterQuestion) {
            return QuestionPage(state: state);
          } else if (state is QuizMasterCategorySelection) {
            return CategoriesPage(
              fragenList: state.fragenList,
              bloc: context.read<QuizMasterBloc>(),
            );
          } else if (state is QuizMasterPoints) {
            return PointsPage(
              state: state,
              bloc: context.read<QuizMasterBloc>(),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
