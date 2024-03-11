import 'package:flutter/material.dart';
import 'package:quizapp/models/fragen.dart';
import 'package:quizapp/service/file_manager_service.dart';

class FragenKatalogPage extends StatefulWidget {
  const FragenKatalogPage({super.key});

  @override
  State<FragenKatalogPage> createState() => _FragenKatalogPageState();
}

class _FragenKatalogPageState extends State<FragenKatalogPage> {
  FileManagerService fileManagerService = const FileManagerService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fragen Katalog')),
      body: FutureBuilder(
        future: fileManagerService.readFragen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          FragenList data = snapshot.data!;
          return ListView.builder(
            itemCount: data.fragen.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(data.fragen[index].thema),
              subtitle: ListView.builder(
                shrinkWrap: true,
                itemCount: data.fragen[index].fragen.length,
                itemBuilder: (context, innerIndex) {
                  return ListTile(
                    title: Text(data.fragen[index].fragen[innerIndex].frage),
                    subtitle:
                        Text(data.fragen[index].fragen[innerIndex].antwort),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
