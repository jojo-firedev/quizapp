import 'package:flutter/material.dart';
import 'package:quizapp/presentation/participants_management/participants_management_page.dart';
import 'package:quizapp/presentation/question/question_page.dart';
import 'package:quizapp/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Turnier',
      theme: getLightThemeData(),
      themeMode: ThemeMode.light,
      routes: {
        '/question': (context) => const QuestionPage(),
        '/participants': (context) => ParticipantsManagementPage(),
      },
      initialRoute: '/participants',
    );
  }
}
