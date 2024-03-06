import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

class QuizMasterPage extends StatefulWidget {
  const QuizMasterPage({super.key});

  @override
  State<QuizMasterPage> createState() => _QuizMasterPageState();
}

class _QuizMasterPageState extends State<QuizMasterPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Global.connectionMode = ConnectionMode.game;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JF Adendorf ist dran')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  'Frage:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Was ist der Anfangsbuchstabe vom ABC',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Antwort:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Die Antwort könnte A sein',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Runde für:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'JF Adendorf',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Gedrückt:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '-',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomButton(
                          icon: Icons.done,
                          color: Colors.green,
                          // text: 'Richtig',
                          text: '',
                          onPressed: () {},
                        ),
                        CustomButton(
                          icon: Icons.close,
                          color: Colors.red,
                          // text: 'Falsch',
                          text: '',
                          onPressed: () {},
                        ),
                        CustomButton(
                          icon: Icons.lock,
                          color: Colors.grey.shade800,
                          text: '',
                          onPressed: () =>
                              Global.buzzerManagerService.sendBuzzerLock(),
                        ),
                        CustomButton(
                          icon: Icons.lock_open,
                          color: Colors.grey.shade800,
                          text: '',
                          onPressed: () =>
                              Global.buzzerManagerService.sendBuzzerRelease(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width / 4.5,
      height: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 10,
                ),
              ),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
