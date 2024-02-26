import 'package:flutter/material.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/dev/test_buzzer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuzzerSocketService _buzzerSocketService;

  @override
  void initState() {
    _buzzerSocketService = BuzzerSocketService();
    super.initState();
  }

  @override
  void dispose() {
    _buzzerSocketService.close();
    super.dispose();
  }

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
          InkWell(
            onTap: () {},
            child: const Card(
              child: Center(
                child: Text('Geführte Bedienung'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/quiz'),
              child: const Center(
                child: Text('Start Quiz'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/teilnehmer'),
              child: const Center(
                child: Text('Teilnehmer Übersicht'),
              ),
            ),
          ),
          Card(
            color: Colors.red,
            child: InkWell(
              onTap: () => testBuzzer(),
              child: const Center(
                child: Text('Send UDP Config',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Card(
            color: Colors.red,
            child: InkWell(
              onTap: () {},
              child: const Center(
                child: Text('Send TCP Message',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {},
              child: const Center(
                child: Text(''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
