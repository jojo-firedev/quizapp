import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';
import 'package:quizapp/service/file_manager_service.dart';

class BuzzerAssignmentPage extends StatefulWidget {
  const BuzzerAssignmentPage({super.key});

  @override
  State<BuzzerAssignmentPage> createState() => _BuzzerAssignmentPageState();
}

class _BuzzerAssignmentPageState extends State<BuzzerAssignmentPage> {
  final FileManagerService csvService = const FileManagerService();

  @override
  void initState() {
    Global.connectionMode = ConnectionMode.assignment;

    Global.buzzerManagerService.sendBuzzerRelease();

    print(Global.connectionMode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buzzer zuordnen'),
        actions: const [
          Text('Tippe auf das Icon und betätige dann den Buzzer.'),
          SizedBox(width: 10)
        ],
      ),
      body: ListView.builder(
        itemCount: Global.sockets.length > Global.jugendfeuerwehren.length
            ? Global.jugendfeuerwehren.length
            : Global.sockets.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('Platz ${index + 1}'),
          trailing: const Icon(Icons.link, color: Colors.red),
          onTap: () {
            Global.currentAssignmentData = index + 1;
          },
          subtitle: Text(Global.jugendfeuerwehren[index].name),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.save),
        label: const Text('Abschließen'),
      ),
    );
  }
}
