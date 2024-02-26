import 'package:flutter/material.dart';
import 'package:quizapp/service/buzzer_socket_service.dart';
import 'package:quizapp/service/dev/test_buzzer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuzzerSocketService _buzzerSocketService;

  @override
  void initState() {
    _buzzerSocketService = BuzzerSocketService(context);
    super.initState();
  }

  @override
  void dispose() {
    _buzzerSocketService.close();
    super.dispose();
  }

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
                onTap: () {},
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
                          'Geführter Modus',
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
                onTap: () => Navigator.pushNamed(context, '/quiz'),
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
                          'Start Quiz',
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
                onTap: () => Navigator.pushNamed(context, '/teilnehmer'),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.group,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Teilnehmer Übersicht',
                          style: TextStyle(fontSize: 20),
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
                onTap: () => testBuzzer(),
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
                onTap: () =>
                    _buzzerSocketService.lockBuzzer('00:00:00:00:00:00'),
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
                          'Lock all Buzzers',
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
                onTap: () => _buzzerSocketService.releaseBuzzer(),
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
                          'Unlock all Buzzers',
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
          stream: _buzzerSocketService.connectedSocketsCountStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Verbundene Buttons: ${snapshot.data}',
                style: TextStyle(fontSize: 20),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
