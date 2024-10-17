import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/teilnehmer.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/file_manager_service.dart';
import 'package:quizapp/service/json_storage_service.dart';

class EinrichtungPage extends StatelessWidget {
  const EinrichtungPage({super.key});

  final JsonStorageService jsonImportService = const JsonStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einrichtung'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Text('1'),
                  title: const Text('JSON importieren'),
                  subtitle: const Text(
                      'JSON-Dateien für Voreinstellungen importieren'),
                  onTap: () => jsonImportService.importCompleteJsonFile(),
                ),
                ListTile(
                  leading: const Text('2'),
                  title: const Text('Jugendfeuerwehren importieren'),
                  subtitle: const Text(
                      'Jugendfeuerwehren für den Wettbewerb aus JSON importieren'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/jf_assignment'),
                ),
                ListTile(
                  leading: const Text('3'),
                  title: const Text('Buzzer verbinden'),
                  subtitle:
                      const Text('Verbindung mit allen Buzzer herstellen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_paring'),
                ),
                ListTile(
                  leading: const Text('4'),
                  title: const Text('Buzzer zuordnen'),
                  subtitle: const Text('Buzzer den Jugendfeuerwehren zuordnen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_assignment'),
                ),
                ListTile(
                  leading: const Text('5'),
                  title: const Text('Einrichtung abschließen'),
                  onTap: () {
                    for (Jugendfeuerwehr jf in Global.jugendfeuerwehren) {
                      try {
                        if (Global.buzzerTischZuordnung
                            .where((element) => element.tisch == jf.tisch)
                            .isEmpty) {
                          continue;
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).popAndPushNamed('/quiz-master');
                },
                title: const Text('Quiz starten',
                    style: TextStyle(color: Colors.white)),
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
