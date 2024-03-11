import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({
    required this.state,
    required this.bloc,
    Key? key,
  }) : super(key: key);

  final QuizMasterPoints state;
  final QuizMasterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Punktevergabe')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('JF Adendorf'),
            subtitle: Text('Aktuell: -20'),
            trailing: SizedBox(
              width: 100,
              // height: 20,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(SavePoints());
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
