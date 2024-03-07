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
      ),
      body: FutureBuilder(
        future: fileManagerService.readAllJFsFromJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Jugendfeuerwehr> jfs = snapshot.data as List<Jugendfeuerwehr>;
            return ListView.builder(
              itemCount: jfs.length,
              itemBuilder: (context, index) {
                Jugendfeuerwehr jf = jfs[index];
                return ListTile(
                  title: Text(jf.name),
                  leading: Text(jf.reihenfolge.toString()),
                  trailing: Text('Tisch ${jf.tisch}'),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Keine Jugendfeuerwehren gefunden'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Global.jugendfeuerwehren =
              await fileManagerService.readAllJFsFromJson();
          Navigator.of(context).popAndPushNamed('/einrichtung/buzzer_paring');
        },
        icon: const Icon(Icons.save),
        label: const Text('Speichern und weiter'),
      ),
    );
  }
}
