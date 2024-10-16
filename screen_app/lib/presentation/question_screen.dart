import 'dart:async';

import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.question,
    required this.category,
    this.jugendfeuerwehr,
    this.answer,
    this.countdown,
  });

  final String question;
  final String category;
  final String? jugendfeuerwehr;
  final String? answer;
  final int? countdown;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int countdown = -1; // Starte Countdown bei 10 Sekunden
  Timer? timer;

  @override
  void initState() {
    print('Countdown: ${widget.countdown}');
    super.initState();
    startCountdown(widget.countdown ?? -1);
  }

  void startCountdown(int startCountdown) {
    countdown = startCountdown;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            top: 20,
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.question,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.answer ?? '',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          if (countdown != -1)
            Positioned(
              bottom: 50, // Abstand vom unteren Rand
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  countdown.toString(),
                  style: const TextStyle(
                    fontSize: 40, // Große Schrift für den Countdown
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          if (countdown != -1)
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: LinearProgressIndicator(
                  value: (countdown.toDouble() / (widget.countdown ?? 0)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
