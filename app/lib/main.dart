import 'package:flutter/material.dart';
import 'package:quizapp/gobals.dart';
import 'package:quizapp/presentation/einrichtung/buzzer_config/1_buzzer_paring_page.dart';
import 'package:quizapp/presentation/einrichtung/buzzer_config/2_buzzer_config_page.dart';
import 'package:quizapp/presentation/einrichtung/einrichtung_page.dart';
import 'package:quizapp/presentation/einstellungen/einstellung_page.dart';
import 'package:quizapp/presentation/home/home_page.dart';
import 'package:quizapp/presentation/quiz/quiz_page.dart';
import 'package:quizapp/presentation/teilnehmer_uebersicht/teilnehmer_uebersicht_page.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/style.dart';

void main() {
  Global.buzzerSocketService = BuzzerSocketService();
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
        '/einrichtung/buzzer_paring': (context) => const BuzzerParingPage(),
        '/einrichtung/buzzer_config': (context) => const BuzzerConfigPage(),
        '/quiz': (context) => const QuizPage(),
        '/teilnehmer': (context) => const TeilnehmerUebersichtPage(),
        '/einstellungen': (context) => const EinstellungPage(),
      },
      initialRoute: '/',
    );
  }
}
