import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:quizapp/globals.dart';

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
      Global.logger.d('Server started on port ${_serverSocket!.port}');
      _serverSocket!.listen((Socket clientSocket) {
        _handleClient(clientSocket);
      });
    } catch (e) {
      Global.logger.d('Error starting server: $e');
    }
  }

  void _startKeepAlive() {
    _keepAliveTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) => sendPing(),
    );
  }

  void _handleClient(Socket clientSocket) {
    Global.logger.d(
      'Client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}',
    );
    Global.sockets.add(clientSocket);
    updateConnectedSocketsCount();

    clientSocket.listen((List<int> data) {
      String message = utf8.decode(data);
      Global.buzzerManagerService.handleMessage(message, clientSocket);
    }, onError: (error) {
      Global.logger.d('Error with client: $error');
      Global.sockets.remove(clientSocket);
      updateConnectedSocketsCount();
    }, onDone: () {
      Global.logger.d(
          'Client disconnected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
      Global.sockets.remove(clientSocket);
      updateConnectedSocketsCount();
    });
  }

  void _sendMessageToAll(String message, {Socket? senderSocket}) {
    for (var socket in Global.sockets) {
      Global.logger
          .d('Sending message "$message" to: ${socket.remoteAddress.address}');
      if (socket == senderSocket && senderSocket != null) {
        continue;
      }
      socket.write(message);
    }
  }

  void sendBuzzerLock({List<String>? macs}) {
    macs ??= [];
    String lockMessage = jsonEncode({'ButtonLock': macs});

    _sendMessageToAll(lockMessage);
  }

  void sendBuzzerRelease({List<String>? macs}) {
    macs ??= [];

    String resetMessage = jsonEncode({'ButtonRelease': macs});
    _sendMessageToAll(resetMessage);
  }

  void sendPing() {
    String pingMessage = '["Ping"]';

    _sendMessageToAll(pingMessage);
  }

  void stopListening() {
    _serverSocket?.close();
    _keepAliveTimer?.cancel();
    for (var socket in Global.sockets) {
      socket.destroy();
    }
  }
}
