import 'package:flutter/material.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class BuzzerParingPage extends StatefulWidget {
  const BuzzerParingPage({super.key});

  @override
  State<BuzzerParingPage> createState() => _BuzzerParingPageState();
}

class _BuzzerParingPageState extends State<BuzzerParingPage> {
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () => BuzzerManagerService().sendConfig(),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Buzzer konfigurieren',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                "Die Buzzer sind verbunden, wenn die LED im Buzzer dauerhaft Lila leuchtet."),
            const Text(
                'Sobald alle Buzzer lila leuchten, drücke auf "Verbinden".'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                setState(() {
                  BuzzerManagerService().connectAllBuzzer();
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Verbinden',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                'Sobald die Buzzer weiß leuchten, müssen alle Buzzer nacheinander betätigt werden.'),
            const SizedBox(height: 20),
            const Text(
                'Wenn alle Buzzer betätigt wurden, drücke auf "Weiter".'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/einrichtung/buzzer_assignment');
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Weiter',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
