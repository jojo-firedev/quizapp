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

  @override
  void initState() {
    Global.connectionMode = ConnectionMode.assignment;
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
      body: StreamBuilder(
        stream: Global.streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<List<Jugendfeuerwehr>>(
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
                          BuzzerManagerService()
                              .assignBuzzer(name: name, gemeinde: gemeinde);
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
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
