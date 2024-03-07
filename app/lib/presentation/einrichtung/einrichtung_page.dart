import 'package:flutter/material.dart';

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
                  title: const Text('Jugendfeuerwehren importieren'),
                  subtitle: const Text(
                      'Jugendfeuerwehren für den Wettbewerb aus JSON importieren'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/jf_assignment'),
                ),
                ListTile(
                  title: const Text('Buzzer verbinden'),
                  subtitle:
                      const Text('Verbindung mit allen Buzzer herstellen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_paring'),
                ),
                ListTile(
                  title: const Text('Buzzer zuordnen'),
                  subtitle: const Text('Buzzer den Jugendfeuerwehren zuordnen'),
                  onTap: () => Navigator.of(context)
                      .pushNamed('/einrichtung/buzzer_assignment'),
                ),
                ListTile(
                  title: const Text('Einrichtung abschließen'),
                  onTap: () {},
                  enabled: false,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context).popAndPushNamed('/quiz-master'),
            title: const Text('Quiz starten',
                style: TextStyle(color: Colors.white)),
            tileColor: Colors.red,
            enabled: false,
            trailing: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
