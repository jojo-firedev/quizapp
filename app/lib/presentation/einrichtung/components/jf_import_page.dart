import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/file_manager_service.dart';

class JfImportPage extends StatefulWidget {
  const JfImportPage({Key? key}) : super(key: key);

  @override
  State<JfImportPage> createState() => _JfImportPageState();
}

class _JfImportPageState extends State<JfImportPage> {
  FileManagerService fileManagerService = const FileManagerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugendfeuerwehren importieren'),
        actions: const [
          Text(
              'Wenn die Liste der Jugendfeuerwehren stimmt, drücke auf "Speichern und weiter"')
        ],
      ),
      body: ListView.builder(
        itemCount: Global.jugendfeuerwehren.length,
        itemBuilder: (context, index) {
          Jugendfeuerwehr jf = Global.jugendfeuerwehren[index];
          return ListTile(
            title: Text(jf.name),
            leading: Text(jf.reihenfolge.toString()),
            trailing: Text('Tisch ${jf.tisch}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!context.mounted) return;
          Navigator.of(context).popAndPushNamed('/einrichtung/buzzer_paring');
        },
        icon: const Icon(Icons.save),
        label: const Text('Weiter'),
      ),
    );
  }
}
