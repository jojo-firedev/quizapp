import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/service/csv_service.dart';

class TeilnehmerUebersichtPage extends StatelessWidget {
  final CsvService csvService = CsvService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teilnehmerübersicht'),
      ),
      body: FutureBuilder<List<Jugendfeuerwehr>>(
        future: csvService.readCsv(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final groupedData =
                groupBy(data, (Jugendfeuerwehr j) => j.gemeinde);
            return ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                final gemeinde = groupedData.keys.elementAt(index);
                final feuerwehren = groupedData[gemeinde];
                return ExpansionTile(
                  title: Text(gemeinde),
                  children: feuerwehren!
                      .map((f) => ListTile(
                            title: Text(f.name),
                            // subtitle: Text('Ort: ${f.ort}'),
                          ))
                      .toList(),
                );
              },
            );
            // if (snapshot.hasData) {
            //   final data = snapshot.data!;
            //   return ListView.builder(
            //     itemCount: data.length,
            //     itemBuilder: (context, index) {
            //       final gemeinde = data[index].gemeinde;
            //       final ort = data[index].ort;
            //       final name = data[index].name;
            //       return ListTile(
            //         title: Text(name),
            //         subtitle: Text('Gemeinde/Stadt: $gemeinde'),
            //       );
            //     },
            //   );
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
