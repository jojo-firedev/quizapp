import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

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
      (Timer t) => _sendKeepAlive(),
    );
  }

  void _sendKeepAlive() {
    String keepAliveMessage = jsonEncode({'KeepAlive': []});
    _sendMessageToAll(keepAliveMessage);
  }

  void _handleClient(Socket clientSocket) {
    Global.logger.d(
        'Client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
    Global.sockets.add(clientSocket);
    updateConnectedSocketsCount();

    clientSocket.listen((List<int> data) {
      BuzzerManagerService(BuzzerType.silent).handleMessage(
        data,
        clientSocket.remoteAddress.address,
        clientSocket.remotePort,
      );
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
      if (socket == senderSocket && senderSocket != null) {
        continue;
      }
      socket.write(message);
    }
  }

  void sendBuzzerLock({String? winnerMac}) {
    String lockMessage = jsonEncode({
      'ButtonLock': [winnerMac]
    });

    _sendMessageToAll(lockMessage);
  }

  void sendBuzzerRelease() {
    String resetMessage = jsonEncode({'ButtonRelease': []});
    _sendMessageToAll(resetMessage);
  }

  void sendPing() {
    String pingMessage = jsonEncode({
      'Ping': ["Ping"]
    });

    _sendMessageToAll(pingMessage);
  }

  void close() {
    _serverSocket?.close();
    _keepAliveTimer?.cancel();
    for (var socket in Global.sockets) {
      socket.destroy();
    }
  }
}
