import 'dart:convert';
import 'dart:io';

class BuzzerSocketService {
  List<Socket> _sockets = [];
  List<String> _macs = [];
  ServerSocket? _serverSocket;

  BuzzerSocketService() {
    _startServer();
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

  void _handleClient(Socket clientSocket) {
    print(
        'Client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
    _sockets.add(clientSocket);

    clientSocket.listen((List<int> data) {
      String message = utf8.decode(data);
      Map<String, dynamic> jsonObject = jsonDecode(message);
      if (jsonObject.values.first == 'Connected') {
        String mac = jsonObject.keys.first;
        _macs.add(mac);
      } else if (jsonObject.values.first == 'ButtonPressed') {
        String mac = jsonObject.keys.first;
        lockBuzzer(mac);
      }
      print(
          'Received message from ${clientSocket.remoteAddress}:${clientSocket.remotePort}: $message');
    }, onError: (error) {
      print('Error with client: $error');
      _sockets.remove(clientSocket);
    }, onDone: () {
      print(
          'Client disconnected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
      _sockets.remove(clientSocket);
    });
  }

  void _sendMessageToAll(String message, {Socket? senderSocket}) {
    for (var socket in _sockets) {
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
    for (var socket in _sockets) {
      socket.destroy();
    }
  }
}
