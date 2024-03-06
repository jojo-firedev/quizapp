import 'package:flutter/material.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/file_manager_service.dart';

class JfAssignmentPage extends StatefulWidget {
  const JfAssignmentPage({Key? key}) : super(key: key);

  @override
  State<JfAssignmentPage> createState() => _JfAssignmentPageState();
}

class _JfAssignmentPageState extends State<JfAssignmentPage> {
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
    );
  }
}
