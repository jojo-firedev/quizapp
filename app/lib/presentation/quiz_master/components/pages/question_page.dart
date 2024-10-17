import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';
import 'package:quizapp/presentation/quiz_master/components/custom_button.dart';

class QuestionPage extends StatelessWidget {
  final QuizMasterQuestion state;

  const QuestionPage({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      'Frage:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      state.frage.frage,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Antwort:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      state.frage.antwort,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          state.currentJf,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Gedrückt:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          state.pressedJf,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state is QuizMasterQuestionConfirmShowAnswer)
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
                                text: 'Antwort anzeigen',
                                onPressed: () => context
                                    .read<QuizMasterBloc>()
                                    .add(ShowAnswer()),
                              ),
                              CustomButton(
                                icon: Icons.fast_forward,
                                color: Colors.blue,
                                text: 'Nächste Frage',
                                onPressed: () => context
                                    .read<QuizMasterBloc>()
                                    .add(ShowNextQuestion()),
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
                )
              else if (state is QuizMasterQuestionShowAnswer)
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
                                icon: Icons.fast_forward,
                                color: Colors.blue,
                                text: 'Nächste Frage',
                                onPressed: () => context
                                    .read<QuizMasterBloc>()
                                    .add(ShowNextQuestion()),
                              ),
                              // CustomButton(
                              //   icon: Icons.close,
                              //   color: Colors.red,
                              //   text: 'Antwort nicht anzeigen',
                              //   onPressed: () => context
                              //       .read<QuizMasterBloc>()
                              //       .add(WrongAnswer()),
                              // ),
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
                )
              else
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
                                onPressed: () => context
                                    .read<QuizMasterBloc>()
                                    .add(WrongAnswer()),
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
        ],
      ),
    );
  }
}
