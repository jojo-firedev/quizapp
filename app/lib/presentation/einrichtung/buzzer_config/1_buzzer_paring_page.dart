import 'package:flutter/material.dart';
import 'package:quizapp/gobals.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerParingPage extends StatefulWidget {
  const BuzzerParingPage({super.key});

  @override
  State<BuzzerParingPage> createState() => _BuzzerParingPageState();
}

class _BuzzerParingPageState extends State<BuzzerParingPage> {
  @override
  void initState() {
    // Global.buzzerSocketService!.updateConnectedSocketsCount();
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                setState(() {
                  BuzzerUdpService().sendConfigWithIP();
                  Global.printSockets();
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.send_time_extension,
                      color: Colors.white,
                      // size: MediaQuery.of(context).size.width / 10,
                      size: 50,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Buzzer konfigurieren',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
                'Schließen Sie alle Buzzer an die Stromversorgung an und drücke Sie auf "Buzzer konfigurieren".'),
            Container(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<int>(
                stream: Global.buzzerSocketService!.connectedSocketsCountStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Verbundene Buzzer: ${snapshot.data}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                "Wenn alle Buzzer verbunden sind, drücken Sie auf 'Weiter'."),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/einrichtung/buzzer_config');
              },
              child: const Text('Weiter'),
            ),
          ],
        ),
      ),
    );
  }
}
