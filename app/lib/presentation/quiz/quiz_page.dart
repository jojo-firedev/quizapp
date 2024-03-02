import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/presentation/quiz/components/card_element.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _countdownSeconds = 30;
  final TextStyle _questionStyle =
      const TextStyle(fontSize: 50, fontWeight: FontWeight.w500);
  final TextStyle _optionStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.w500);
  final TextStyle _countdownStyle = const TextStyle(fontSize: 30);
  final Color _questionBackgroundColor = Colors.grey[300]!;
  final Color _optionBackgroundColor = Colors.grey[400]!;
  Color _correctAnswerColor = Colors.grey[400]!;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _countdownSeconds),
    )..reverse(from: 1.0);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Countdown completed, handle your action here
        Global.logger.d('Countdown completed');
      }
    });
  }

  String _formatDuration(Duration duration) {
    return '${duration.inSeconds}s';
  }

  void changeColor() {
    setState(() {
      // Change color here
      _correctAnswerColor = _correctAnswerColor == _optionBackgroundColor
          ? Colors.green
          : _optionBackgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CardElement(
                  backgroundColor: _questionBackgroundColor,
                  child: Text(
                    "Im Alarmfall besteht für aktive Mitglieder einer Freiwilligen Feuerwehr die Verpflichtung",
                    style: _questionStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CardElement(
                        backgroundColor: _optionBackgroundColor,
                        child: Text(
                          "beim Ortsbrandmeister telefonisch zurückzurufen.",
                          style: _optionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CardElement(
                        backgroundColor: _optionBackgroundColor,
                        child: Text(
                          "sich unverzüglich am Feuerwehrhaus einzufinden.",
                          style: _optionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CardElement(
                        backgroundColor: _optionBackgroundColor,
                        child: Text(
                          "sich bei der Feuerwehr-Einsatzleitstelle telefonisch nach der Dringlichkeit des",
                          style: _optionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CardElement(
                        backgroundColor: _correctAnswerColor,
                        child: Text(
                          "sich bei der Feuerwehr-Einsatzleitstelle telefonisch nach der Dringlichkeit des Einsatzes zu erkundigen.",
                          style: _optionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final remainingTime = _formatDuration(
                  Duration(
                      seconds:
                          (_controller.duration!.inSeconds * _controller.value)
                              .round()),
                );
                return Column(
                  children: [
                    Text(
                      'Verbleibend: $remainingTime',
                      style: _countdownStyle,
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: _controller.value,
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    _controller.reverse(from: 1.0);
                  }
                });
              },
              child: Icon(
                  _controller.isAnimating ? Icons.pause : Icons.play_arrow),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: changeColor,
              child: const Icon(Icons.remove_red_eye),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
