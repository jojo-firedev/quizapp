import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';
import 'package:quizapp/presentation/quiz_master/components/custom_button.dart';

class QuizQuestionPage extends StatelessWidget {
  final QuizMasterQuestion state;

  const QuizQuestionPage({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${state.currentJf} ist dran')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  'Frage:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  state.question,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Antwort:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  state.answer,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'Runde für:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      state.currentJf,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Gedrückt:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      state.pressedJf,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomButton(
                          icon: Icons.done,
                          color: Colors.green,
                          // text: 'Richtig',
                          text: '',
                          onPressed: () => context
                              .read<QuizMasterBloc>()
                              .add(CorrectAnswer()),
                        ),
                        CustomButton(
                          icon: Icons.close,
                          color: Colors.red,
                          // text: 'Falsch',
                          text: '',
                          onPressed: () =>
                              context.read<QuizMasterBloc>().add(WrongAnswer()),
                        ),
                        CustomButton(
                          icon: Icons.lock,
                          color: Colors.grey.shade800,
                          text: '',
                          onPressed: () => context
                              .read<QuizMasterBloc>()
                              .add(LockAllBuzzers()),
                        ),
                        CustomButton(
                          icon: Icons.lock_open,
                          color: Colors.grey.shade800,
                          text: '',
                          onPressed: () => context
                              .read<QuizMasterBloc>()
                              .add(ReleaseAllBuzzers()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
