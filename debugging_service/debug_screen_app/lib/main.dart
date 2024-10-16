import 'package:flutter/material.dart';
import 'socket_service.dart'; // Import the newly created service class

void main() {
  runApp(ServerApp());
}

class ServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServerHomePage(),
    );
  }
}

class ServerHomePage extends StatefulWidget {
  @override
  _ServerHomePageState createState() => _ServerHomePageState();
}

class _ServerHomePageState extends State<ServerHomePage> {
  late SocketService _socketService;
  String _statusMessage = 'No client connected';

  @override
  void initState() {
    super.initState();
    _socketService = SocketService(onStatusChange: _updateStatus);
    _socketService.startServer();
  }

  void _updateStatus(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  @override
  void dispose() {
    _socketService.closeServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_statusMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _socketService.sendCategories({
                  'Science': true,
                  'Math': true,
                  'Geography': false,
                  'Politics': false,
                });
              },
              child: const Text('Send Categories'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendCategoriesWithFocus({
                  'Science': true,
                  'Math': true,
                  'Geography': false,
                  'Politics': false,
                }, 'Geography');
              },
              child: const Text('Send Categories with focus'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendQuestion(
                  'What is the capital of France?',
                  'Geography',
                  'Team A',
                );
              },
              child: const Text('Send Question'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendCountdown(
                  'What is the capital of France?',
                  'Geography',
                  10,
                );
              },
              child: const Text('Send Countdown'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendAnswer(
                  'What is the capital of France?',
                  'Paris',
                  'Geography',
                  'Team A',
                );
              },
              child: const Text('Send Answer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendScore(42);
              },
              child: const Text('Send Score'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _socketService.sendPointInput(
                  ['Team A', 'Team B'],
                  [3, 2],
                  [-1, 3],
                );
              },
              child: const Text('Send Point Input'),
            ),
          ],
        ),
      ),
    );
  }
}
