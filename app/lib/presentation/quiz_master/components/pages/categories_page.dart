import 'package:flutter/material.dart';
import 'package:quizapp/models/kategorie.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    required this.fragenList,
    required this.bloc,
    Key? key,
  }) : super(key: key);

  final List<Kategorie> fragenList;
  final QuizMasterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategorien')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fragenList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(fragenList[index].thema),
                trailing: const Icon(Icons.arrow_forward_ios),
                enabled: !fragenList[index].abgeschlossen,
                onTap: () {
                  bloc.add(SelectKategorie(fragenList[index].reihenfolge));
                },
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                onTap: () => bloc.add(ShowResults()),
                title: const Text(
                  'Ergebnisse anzeigen',
                  style: TextStyle(color: Colors.white),
                ),
                tileColor: Theme.of(context).colorScheme.primary,
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
