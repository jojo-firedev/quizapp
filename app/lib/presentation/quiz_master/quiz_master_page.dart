import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class QuizMasterPage extends StatefulWidget {
  const QuizMasterPage({super.key});

  @override
  State<QuizMasterPage> createState() => _QuizMasterPageState();
}

class _QuizMasterPageState extends State<QuizMasterPage>
    with SingleTickerProviderStateMixin {
  BuzzerUdpService buzzerUdpService = BuzzerUdpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: const Column(
              children: [
                Text('Frage:'),
                Text('Was ist der Anfangsbuchstabe vom ABC'),
                SizedBox(height: 50),
                Text('Antwort:'),
                Text('Die Antwort könnte A sein')
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const Text('JF Adendorf ist dran:'),
                Row(
                  children: [
                    Card(
                      color: Colors.green,
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width / 10,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Richtig',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                        onTap: () => buzzerUdpService.sendButtonRelease(),
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.width / 10,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Falsch',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Card(
                      color: Colors.grey.shade800,
                      child: InkWell(
                        onTap: () => buzzerUdpService.sendButtonLock(),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey.shade800,
                      child: InkWell(
                        onTap: () => buzzerUdpService.sendButtonRelease(),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
