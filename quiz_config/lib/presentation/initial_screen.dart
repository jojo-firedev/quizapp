import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FilledButton(
        onPressed: () => BlocProvider.of<QuizConfigBloc>(context).add(
          StartNeuenTag(DateTime.now(), 1),
        ),
        child: Text('Neue Config starten'),
      ),
    ));
  }
}
