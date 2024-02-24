import 'package:flutter/material.dart';

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
