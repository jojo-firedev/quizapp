import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({
    super.key,
    required this.question,
    required this.category,
    required this.jugendfeuerwehr,
    this.answer,
    this.countdown,
  });

  final String question;
  final String category;
  final String jugendfeuerwehr;
  final String? answer;
  final int? countdown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: 20,
            child: Text(
              jugendfeuerwehr,
              textAlign: TextAlign.center,
            )),
        Center(
          child: Column(
            children: [
              Text(question),
              if (countdown != null) Text(countdown.toString()),
              if (answer != null) Text(answer!),
            ],
          ),
        ),
      ],
    ));
  }
}
