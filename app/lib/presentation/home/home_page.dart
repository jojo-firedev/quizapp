import 'package:flutter/material.dart';
import 'package:quizapp/service/dev/test_buzzer.dart';
import 'package:quizapp/service/network_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          Card(
            child: InkWell(
              onTap: () {},
              child: const Center(
                child: Text('Geführte Bedienung'),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/quiz'),
            child: const Card(
              child: Center(
                child: Text('Start Quiz'),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/teilnehmer'),
            child: const Card(
              child: Center(
                child: Text('Teilnehmer Übersicht'),
              ),
            ),
          ),
          InkWell(
            onTap: () => testBuzzer(),
            child: const Card(
              child: Center(
                child: Text('Test'),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Card(
              child: Center(
                child: Text(''),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Card(
              child: Center(
                child: Text(''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
