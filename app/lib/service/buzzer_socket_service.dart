import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizapp/gobals.dart';

class BuzzerSocketService {
  ServerSocket? _serverSocket;
  Timer? _keepAliveTimer;

  final _connectedSocketsCountController = StreamController<int>.broadcast();

  // Stream erhalten
  Stream<int> get connectedSocketsCountStream =>
      _connectedSocketsCountController.stream;

  // Methode zum Aktualisieren des Streams
  void updateConnectedSocketsCount() {
    _connectedSocketsCountController.add(Global.sockets.length);
  }

  BuzzerSocketService() {
    _startServer();
    _startKeepAlive();
  }

  void _startServer() async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 8082);
      print('Server started on port ${_serverSocket!.port}');
      _serverSocket!.listen((Socket clientSocket) {
        _handleClient(clientSocket);
      });
    } catch (e) {
      print('Error starting server: $e');
    }
  }

  void _startKeepAlive() {
    _keepAliveTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) => _sendKeepAlive(),
    );
  }

  void _sendKeepAlive() {
    String keepAliveMessage = jsonEncode({'KeepAlive': []});
    _sendMessageToAll(keepAliveMessage);
  }

  void _handleClient(Socket clientSocket) {
    print(
        'Client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
    Global.sockets.add(clientSocket);
    updateConnectedSocketsCount();

    clientSocket.listen((List<int> data) {
      String message = utf8.decode(data);
      Map<String, dynamic> jsonObject = jsonDecode(message);

      if (jsonObject.values.first == 'Connected') {
        String mac = jsonObject.keys.first;
        Global.macs.add(mac);
      } else if (jsonObject.values.first == 'ButtonPressed') {
        String mac = jsonObject.keys.first;
        lockBuzzer(mac);
      }
      print(
          'Received message from ${clientSocket.remoteAddress}:${clientSocket.remotePort}: $message');
    }, onError: (error) {
      print('Error with client: $error');
      Global.sockets.remove(clientSocket);
      updateConnectedSocketsCount();
    }, onDone: () {
      print(
          'Client disconnected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
      Global.sockets.remove(clientSocket);
      updateConnectedSocketsCount();
    });
  }

  void _sendMessageToAll(String message, {Socket? senderSocket}) {
    for (var socket in Global.sockets) {
      if (socket == senderSocket && senderSocket != null) {
        continue;
      }
      socket.write(message);
    }
  }

  void lockBuzzer(String winnerMac) {
    String lockMessage = jsonEncode({
      'ButtonLock': [winnerMac]
    });

    _sendMessageToAll(lockMessage);
  }

  void releaseBuzzer() {
    String resetMessage = jsonEncode({'ButtonRelease': []});
    _sendMessageToAll(resetMessage);
  }

  void close() {
    _serverSocket?.close();
    _keepAliveTimer?.cancel();
    for (var socket in Global.sockets) {
      socket.destroy();
    }
  }
}
