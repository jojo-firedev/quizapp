import 'package:flutter/material.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/csv_service.dart';

class TeilnehmerUebersichtPage extends StatelessWidget {
  final CsvService csvService = CsvService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Jugendfeuerwehr>>(
      future: csvService.readCsv(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final gemeinde = data[index].gemeinde;
              final ort = data[index].ort;
              final name = data[index].name;
              return ListTile(
                title: Text(name),
                subtitle: Text('$gemeinde, $ort'),
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
  }
}
