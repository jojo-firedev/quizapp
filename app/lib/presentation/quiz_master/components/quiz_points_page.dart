import 'package:flutter/material.dart';

class QuizPointsPage extends StatelessWidget {
  const QuizPointsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Punktevergabe')),
      body: ListView.builder(
        itemBuilder: (context, index) => const ListTile(
          title: Text('Jugendfeuerwehr'),
          trailing: Row(
            children: [
              Text('Aktuell: ${3}'),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
