import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/jf_buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/file_manager_service.dart';

class EinrichtungPage extends StatelessWidget {
  const EinrichtungPage({Key? key}) : super(key: key);

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
                  leading: const Text('1'),
                  title: const Text('Jugendfeuerwehren importieren'),
                  subtitle: const Text(
                      'Jugendfeuerwehren für den Wettbewerb aus JSON importieren'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/jf_assignment'),
                ),
                ListTile(
                  leading: const Text('2'),
                  title: const Text('Buzzer verbinden'),
                  subtitle:
                      const Text('Verbindung mit allen Buzzer herstellen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_paring'),
                ),
                ListTile(
                  leading: const Text('3'),
                  title: const Text('Buzzer zuordnen'),
                  subtitle: const Text('Buzzer den Jugendfeuerwehren zuordnen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_assignment'),
                ),
                ListTile(
                  leading: const Text('4'),
                  title: const Text('Einrichtung abschließen'),
                  onTap: () {
                    Global.jfBuzzerAssignments = [];
                    for (Jugendfeuerwehr jf in Global.jugendfeuerwehren) {
                      try {
                        if (Global.assignedBuzzer
                            .where((element) => element.tisch == jf.tisch)
                            .isEmpty) {
                          continue;
                        }
                        Global.jfBuzzerAssignments.add(
                          JfBuzzerAssignment(
                            jugendfeuerwehr: jf,
                            buzzerAssignment: Global.assignedBuzzer
                                .where((element) => element.tisch == jf.tisch)
                                .first,
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    }
                    const FileManagerService()
                        .saveJfBuzzerAssignments(Global.jfBuzzerAssignments);
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Lade von JSON Datei'),
                onTap: () async {
                  Global.jfBuzzerAssignments = await const FileManagerService()
                      .readJfBuzzerAssignments();
                },
              ),
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
