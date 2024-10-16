import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

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
  ServerSocket? _serverSocket;
  Socket? _connectedSocket;
  final int _port = 4040;
  String _statusMessage = 'No client connected';

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  void _startServer() async {
    _serverSocket =
        await ServerSocket.bind(InternetAddress.loopbackIPv4, _port);
    _serverSocket?.listen((Socket clientSocket) {
      setState(() {
        _statusMessage = 'Client connected!';
        _connectedSocket = clientSocket;
      });

      clientSocket.listen((data) {
        print('Received data: ${utf8.decode(data)}');
      });
    });
    setState(() {
      _statusMessage = 'Waiting for client connection on port $_port...';
    });
  }

  void _sendData(Map<String, dynamic> data) {
    if (_connectedSocket != null) {
      String jsonData = jsonEncode(data);
      _connectedSocket?.write(jsonData);
      print('Sent: $jsonData');
    } else {
      print('No client connected!');
    }
  }

  @override
  void dispose() {
    _serverSocket?.close();
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
                _sendData({
                  'type': 'categories',
                  'categories': ['Science', 'Math', 'History']
                });
              },
              child: const Text('Send Categories'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData({
                  'type': 'question',
                  'question': 'What is the capital of France?',
                  'category': 'Geography',
                  'jugendfeuerwehr': 'Team A'
                });
              },
              child: const Text('Send Question'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData({
                  'type': 'countdown',
                  'question': 'What is the capital of France?',
                  'category': 'Geography',
                  'countdown': 10
                });
              },
              child: const Text('Send Countdown'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData({
                  'type': 'answer',
                  'question': 'What is the capital of France?',
                  'answer': 'Paris',
                  'category': 'Geography',
                  'jugendfeuerwehr': 'Team A'
                });
              },
              child: const Text('Send Answer'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData({'type': 'score', 'score': 42});
              },
              child: const Text('Send Score'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData({
                  'type': 'point_input',
                  'jugendfeuerwehrPoints': {'Team A': 5, 'Team B': 3}
                });
              },
              child: const Text('Send Point Input'),
            ),
          ],
        ),
      ),
    );
  }
}
