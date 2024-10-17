import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';

import 'package:quizapp/presentation/einrichtung/components/buzzer_paring_page.dart';
import 'package:quizapp/presentation/einrichtung/components/buzzer_assignment_page.dart';
import 'package:quizapp/presentation/einrichtung/components/jf_import_page.dart';
import 'package:quizapp/presentation/einrichtung/einrichtung_page.dart';
import 'package:quizapp/presentation/home/home_page.dart';
import 'package:quizapp/presentation/quiz_master/quiz_master_page.dart';

import 'package:quizapp/service/buzzer_manager_service.dart';

void main() {
  Global.buzzerType = BuzzerType.socket;

  Global.screenAppService.startServer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Turnier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      themeMode: ThemeMode.light,
      routes: {
        '/': (context) => const HomePage(),
        '/einrichtung': (context) => const EinrichtungPage(),
        '/einrichtung/jf_assignment': (context) => const JfImportPage(),
        '/einrichtung/buzzer_paring': (context) => const BuzzerParingPage(),
        '/einrichtung/buzzer_assignment': (context) =>
            const BuzzerAssignmentPage(),
        '/quiz-master': (context) => const QuizMasterPage(),
      },
      initialRoute: '/',
    );
  }
}
