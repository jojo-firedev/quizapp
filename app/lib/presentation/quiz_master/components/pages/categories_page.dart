import 'package:flutter/material.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    required this.fragenList,
    required this.bloc,
    Key? key,
  }) : super(key: key);

  final FragenList fragenList;
  final QuizMasterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategorien')),
      body: ListView.builder(
        itemCount: fragenList.fragen.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(fragenList.fragen[index].thema),
          trailing: const Icon(Icons.arrow_forward_ios),
          enabled: !fragenList.fragen[index].abgeschlossen,
          onTap: () {
            bloc.add(CategorySelected(fragenList.fragen[index].reihenfolge));
          },
        ),
      ),
    );
  }
}
