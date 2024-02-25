import 'package:flutter/material.dart';
import 'package:quizapp/presentation/home/home_page.dart';
import 'package:quizapp/presentation/quiz/quiz_page.dart';
import 'package:quizapp/presentation/teilnehmer_uebersicht/teilnehmer_uebersicht_page.dart';
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
        '/': (context) => const HomePage(),
        '/quiz': (context) => const QuizPage(),
        '/teilnehmer': (context) => TeilnehmerUebersichtPage(),
      },
      initialRoute: '/',
    );
  }
}
