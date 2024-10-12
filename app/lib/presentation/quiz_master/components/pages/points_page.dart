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
      body: ListView.builder(
        itemCount: state.jfBuzzerAssignments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title:
                  Text(state.jfBuzzerAssignments[index].jugendfeuerwehr.name),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    bloc.add(PointsUpdated(
                      jfTisch: state
                          .jfBuzzerAssignments[index].jugendfeuerwehr.tisch,
                      points: int.parse(value),
                    ));
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(ConfirmPoints());
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
