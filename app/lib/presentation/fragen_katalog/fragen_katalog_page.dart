import 'package:flutter/material.dart';
import 'package:quizapp/service/file_manager_service.dart';

class FragenKatalogPage extends StatefulWidget {
  const FragenKatalogPage({super.key});

  @override
  State<FragenKatalogPage> createState() => _FragenKatalogPageState();
}

class _FragenKatalogPageState extends State<FragenKatalogPage> {
  FileManagerService fileManagerService = FileManagerService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fragen Katalog')),
      body: FutureBuilder(future: fileManagerService.readFragenFromJson(),builder: (context, snapshot) => ListView.builder(itemBuilder: (context, index) => ListTile(title: Text(snapshot.data.fragen.)),),),
    );
  }
}
