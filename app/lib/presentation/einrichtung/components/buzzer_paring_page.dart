import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class BuzzerParingPage extends StatefulWidget {
  const BuzzerParingPage({super.key});

  @override
  State<BuzzerParingPage> createState() => _BuzzerParingPageState();
}

class _BuzzerParingPageState extends State<BuzzerParingPage> {
  @override
  void initState() {
    Global.connectionMode = ConnectionMode.parring;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buzzer verbinden'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                'Schließe alle Buzzer an die Stromversorgung an und drücke auf "Buzzer konfigurieren".'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Global.buzzerManagerService.sendConfig(),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Buzzer konfigurieren',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                "Die Buzzer sind verbunden, wenn die LED im Buzzer dauerhaft Gelb leuchtet."),
            const SizedBox(height: 20),
            StreamBuilder<int>(
              stream: Global.buzzerManagerService.buzzerSocketService
                  .connectedSocketsCountStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Verbundene Buzzer: ${snapshot.data}',
                    style: const TextStyle(fontSize: 20),
                  );
                } else {
                  if (Global.sockets.isNotEmpty) {
                    return Text(
                      'Verbundene Buzzer: ${Global.sockets.length}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade800,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('Wenn alle Buzzer verbunden sind, drücke auf "Weiter".'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context)
              .popAndPushNamed('/einrichtung/buzzer_assignment');
        },
        icon: const Icon(Icons.save),
        label: const Text('Weiter'),
      ),
    );
  }
}
