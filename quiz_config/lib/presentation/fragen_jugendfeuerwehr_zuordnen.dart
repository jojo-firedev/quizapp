import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';
import 'package:quiz_config/models/json_export_file.dart';

class FragenJugendfeuerwehrZuordnenScreen extends StatefulWidget {
  final List<ExportTeilnehmer>? teilnehmer;
  final List<ExportKategorie>? kategorien;

  FragenJugendfeuerwehrZuordnenScreen(
      {required this.teilnehmer, required this.kategorien});

  @override
  _FragenJugendfeuerwehrZuordnenScreenState createState() =>
      _FragenJugendfeuerwehrZuordnenScreenState();
}

class _FragenJugendfeuerwehrZuordnenScreenState
    extends State<FragenJugendfeuerwehrZuordnenScreen> {
  ExportTeilnehmer? selectedTeilnehmer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teilnehmer und Kategorien'),
        actions: [
          TextButton.icon(
            label: const Text('Fragen für Jugendfeuerwehren zuordnen'),
            icon: const Icon(Icons.send),
            onPressed: () => BlocProvider.of<QuizConfigBloc>(context)
                .add(FragenJugendfeuerwehrZuordnen()),
          ),
        ],
      ),
      body: Row(
        children: [
          // Linke Liste der Teilnehmer
          Expanded(
            child: ListView.builder(
              itemCount: widget.teilnehmer!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.teilnehmer![index].jugendfeuerwehr?.name ??
                      'Unbekannt'),
                  onTap: () {
                    setState(() {
                      selectedTeilnehmer = widget.teilnehmer![index];
                    });
                  },
                );
              },
            ),
          ),
          // Mittlerer Bereich zeigt die Fragen des ausgewählten Teilnehmers
          Expanded(
            child: selectedTeilnehmer != null
                ? ListView(
                    children: [
                      Text(
                        'Fragen für ${selectedTeilnehmer!.jugendfeuerwehr?.name}:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...selectedTeilnehmer!.fragen!.map((frage) {
                        String kategorieName = widget.kategorien!
                                .firstWhere(
                                  (kategorie) =>
                                      kategorie.reihenfolge ==
                                      frage.kategorieReihenfolge,
                                  orElse: () => ExportKategorie(
                                      name: 'Unbekannte Kategorie'),
                                )
                                .name ??
                            'Unbekannte Kategorie';

                        return ListTile(
                          title: Text(frage.frage ?? 'Keine Frage'),
                          subtitle: Text(
                            'Kategorie: $kategorieName\nAntwort: ${frage.antwort ?? "Keine Antwort"}',
                          ),
                        );
                      }).toList(),
                    ],
                  )
                : Center(
                    child: Text('Bitte einen Teilnehmer auswählen'),
                  ),
          ),
        ],
      ),
    );
  }
}
