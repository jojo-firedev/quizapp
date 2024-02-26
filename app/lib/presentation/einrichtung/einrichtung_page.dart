import 'package:flutter/material.dart';

class EinrichtungPage extends StatelessWidget {
  const EinrichtungPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einrichtung'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Buzzer verbinden'),
            subtitle: const Text('Verbindung mit allen Buzzer herstellen'),
            onTap: () =>
                Navigator.of(context).pushNamed('/einrichtung/buzzer_paring'),
          ),
          const ListTile(
            title: Text('Teilnehmer hinzufügen'),
            subtitle: Text('Teilnehmer hinzufügen'),
          ),
          const ListTile(
            title: Text('Teilnehmer bearbeiten'),
            subtitle: Text('Teilnehmer bearbeiten'),
          ),
          const ListTile(
            title: Text('Teilnehmer löschen'),
            subtitle: Text('Teilnehmer löschen'),
          ),
        ],
      ),
    );
  }
}
