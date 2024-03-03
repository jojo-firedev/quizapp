import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';
import 'package:quizapp/service/csv_service.dart';

class BuzzerAssignmentPage extends StatefulWidget {
  const BuzzerAssignmentPage({super.key});

  @override
  State<BuzzerAssignmentPage> createState() => _BuzzerAssignmentPageState();
}

class _BuzzerAssignmentPageState extends State<BuzzerAssignmentPage> {
  final CsvService csvService = const CsvService();
  final BuzzerManagerService _buzzerManagerService = BuzzerManagerService();

  @override
  void initState() {
    Global.connectionMode = ConnectionMode.assignment;
    _buzzerManagerService.setup();
    _buzzerManagerService.listenToStream();
    _buzzerManagerService.sendBuzzerRelease();

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
      body: FutureBuilder<List<Jugendfeuerwehr>>(
        future: csvService.readCsv(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final gemeinde = data[index].gemeinde;
                final name = data[index].name;
                return ListTile(
                  title: Text(name),
                  subtitle: Text(gemeinde),
                  trailing: const Icon(Icons.link, color: Colors.red),
                  onTap: () {
                    Global.currentAssignmentData = data[index];
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
