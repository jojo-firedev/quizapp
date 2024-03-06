import 'package:flutter/material.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/file_manager_service.dart';

class EinstellungPage extends StatefulWidget {
  const EinstellungPage({super.key});

  @override
  State<EinstellungPage> createState() => _EinstellungPageState();
}

class _EinstellungPageState extends State<EinstellungPage> {
  FileManagerService fileManagerService = const FileManagerService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () => fileManagerService.saveJFsToJson([
              Jugendfeuerwehr(reihenfolge: 1, name: 'Test', tisch: 1),
              Jugendfeuerwehr(reihenfolge: 2, name: 'Test2', tisch: 2),
              Jugendfeuerwehr(reihenfolge: 3, name: 'pwerigj', tisch: 3),
            ]),
            child: Text('Save JF to CSV'),
          )
        ],
      )),
    );
  }
}
