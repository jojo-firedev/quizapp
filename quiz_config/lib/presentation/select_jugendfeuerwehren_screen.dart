import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';

class SelectJugendfeuerwehrenScreen extends StatelessWidget {
  const SelectJugendfeuerwehrenScreen({
    super.key,
    required this.jugendfeuerwehren,
    required this.ausgewaehlteJugendfeuerwehren,
  });

  final List<Jugendfeuerwehr> jugendfeuerwehren;
  final List<Jugendfeuerwehr> ausgewaehlteJugendfeuerwehren;

  @override
  Widget build(BuildContext context) {
    Widget _buildSelectedItemTile(int index) {
      return ListTile(
        key: ValueKey(ausgewaehlteJugendfeuerwehren[index].name),
        title: Text(ausgewaehlteJugendfeuerwehren[index].name),
        subtitle: Text(ausgewaehlteJugendfeuerwehren[index].gemeinde),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => BlocProvider.of<QuizConfigBloc>(context).add(
            RemoveJugendfeuerwehr(index),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wähle Jugendfeuerwehren aus'),
      ),
      body: Row(
        children: [
          // Available Items List
          Expanded(
            child: Column(
              children: [
                const Text('Jugendfeuerwehren im Landkreis',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: jugendfeuerwehren.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(jugendfeuerwehren[index].name),
                        subtitle: Text(jugendfeuerwehren[index].gemeinde),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () =>
                              BlocProvider.of<QuizConfigBloc>(context).add(
                            SelectJugendfeuerwehr(
                              jugendfeuerwehren[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Selected Items List
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Ausgewählte Jugendfeuerwehren',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) =>
                        BlocProvider.of<QuizConfigBloc>(context).add(
                      ReoderJugendfeuerwehr(oldIndex, newIndex),
                    ),
                    children: [
                      for (int i = 0;
                          i < ausgewaehlteJugendfeuerwehren.length;
                          i++)
                        _buildSelectedItemTile(i),
                    ],
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
