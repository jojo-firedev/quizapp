import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';

import 'package:quizapp/presentation/einrichtung/components/buzzer_paring_page.dart';
import 'package:quizapp/presentation/einrichtung/components/buzzer_assignment_page.dart';
import 'package:quizapp/presentation/einrichtung/components/jf_import_page.dart';
import 'package:quizapp/presentation/einrichtung/einrichtung_page.dart';
import 'package:quizapp/presentation/einstellungen/einstellung_page.dart';
import 'package:quizapp/presentation/fragen_katalog/fragen_katalog_page.dart';
import 'package:quizapp/presentation/home/home_page.dart';
import 'package:quizapp/presentation/quiz/quiz_page.dart';
import 'package:quizapp/presentation/quiz_master/quiz_master_page.dart';

import 'package:quizapp/service/buzzer_manager_service.dart';
import 'package:quizapp/style.dart';

void main() {
  Global.buzzerType = BuzzerType.socket;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Turnier',
      theme: getLightThemeData(),
      themeMode: ThemeMode.light,
      routes: {
        '/': (context) => const HomePage(),
        '/einrichtung': (context) => const EinrichtungPage(),
        '/einrichtung/jf_assignment': (context) => const JfImportPage(),
        '/einrichtung/buzzer_paring': (context) => const BuzzerParingPage(),
        '/einrichtung/buzzer_assignment': (context) =>
            const BuzzerAssignmentPage(),
        '/fragen_katalog': (context) => const FragenKatalogPage(),
        '/quiz': (context) => const QuizPage(),
        '/quiz-master': (context) => const QuizMasterPage(),
        '/einstellungen': (context) => const EinstellungPage(),
      },
      initialRoute: '/',
    );
  }
}
