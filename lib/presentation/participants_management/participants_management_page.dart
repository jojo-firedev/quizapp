import 'package:flutter/material.dart';
import 'package:quizapp/service/csv_service.dart';

class ParticipantsManagementPage extends StatefulWidget {
  @override
  _ParticipantsManagementPageState createState() =>
      _ParticipantsManagementPageState();
}

class _ParticipantsManagementPageState
    extends State<ParticipantsManagementPage> {
  CsvService csvService = CsvService();
  List<String> participants = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teilnehmer',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                participants[index],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                child: const Icon(Icons.link),
                onPressed: () {
                  csvService.readCsv();
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String newName = participants[index];
                      return AlertDialog(
                        title: Text('Name von $newName ändern'),
                        content: TextField(
                          onChanged: (value) {
                            newName = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Neuer Name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Abbrechen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Bestätigen'),
                            onPressed: () {
                              setState(() {
                                participants[index] = newName;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
