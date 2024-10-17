import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/service/json_storage_service.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.count(
          crossAxisCount: 3,
          childAspectRatio:
              MediaQuery.of(context).size.width / constraints.maxHeight,
          crossAxisSpacing: 10,
          children: [
            Card(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/einrichtung'),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.fast_forward,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Einrichtung',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/quiz-master'),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.quiz,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Starte Quiz',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                onTap: () => Global.buzzerManagerService.sendConfig(),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.send_time_extension,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Send UDP Config',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.red,
              child: InkWell(
                onTap: () => Global.buzzerManagerService.sendBuzzerLock(),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Alle Buzzer sperren',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.green,
              child: InkWell(
                onTap: () => Global.buzzerManagerService.sendBuzzerRelease(),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.lock_open,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Buzzer freigeben',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Buzzer Farbinfo'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blau: nicht mit WLAN verbunden',
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Violet: mit WLAN verbunden, aber keine TCP-Verbindung zum Server',
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gelb: TCP-Verbindung zum Server aufgebaut',
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Weiß: Der Taster kann einmalig betätigt werden',
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rot: Der Taster wurde gesperrt (Gruppe hat nicht als erstes gedückt)',
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Grün: Der Taster wurde gesperrt (Gruppe hat als erstes gedückt)',
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Buzzer Farbinfo',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  windowManager.setFullScreen(true);
                  windowManager.setAlwaysOnTop(true);
                },
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.fullscreen,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Vollbildmodus',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: InkWell(
                onTap: () => Global.screenAppService.startScreenApp(),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.open_in_browser,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Starte Präsentation',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.red,
              child: InkWell(
                onTap: () => JsonStorageService().resetJsonStorage(),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.restore,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'JSON zurücksetzen',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<int>(
          stream: Global.buzzerManagerService.buzzerSocketService
              .connectedSocketsCountStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Verbundene Buzzer: ${snapshot.data}',
                style: const TextStyle(fontSize: 20),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
