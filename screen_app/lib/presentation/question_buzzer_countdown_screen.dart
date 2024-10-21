import 'dart:async';
import 'package:flutter/material.dart';

class QuestionBuzzerCountdownScreen extends StatefulWidget {
  const QuestionBuzzerCountdownScreen({
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
  State<QuestionBuzzerCountdownScreen> createState() =>
      _QuestionBuzzerCountdownScreenState();
}

class _QuestionBuzzerCountdownScreenState
    extends State<QuestionBuzzerCountdownScreen>
    with SingleTickerProviderStateMixin {
  int countdown = -1;
  Timer? timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    countdown = widget.countdown ?? -1;

    if (countdown > 0) {
      _controller = AnimationController(
        duration: Duration(seconds: countdown),
        vsync: this,
      );

      _animation = Tween<double>(begin: countdown.toDouble(), end: 0)
          .animate(_controller)
        ..addListener(() {
          setState(() {
            countdown = _animation.value.toInt();
          });
        });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    if (countdown > 0) _controller.dispose();
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
                  widget.answer ?? '    ',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Text(
                  widget.jugendfeuerwehr ?? '   ',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (countdown != -1)
            Center(
              child: Text(
                countdown.toString(),
                style: const TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
                  value: 1.0 -
                      _controller
                          .value, // Invert the value to make it count down
                ),
              ),
            ),
        ],
      ),
    );
  }
}
