import 'dart:async';
import 'dart:convert';
import 'dart:io';

class BuzzerSocketService {
  List<Socket> _sockets = [];
  ServerSocket? _serverSocket;

  BuzzerSocketService() {
    _startServer();
  }

  void _startServer() async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 12345);
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
      print(
          'Received message from ${clientSocket.remoteAddress}:${clientSocket.remotePort}: $message');
      _sendMessageToAll(message, clientSocket);
    }, onError: (error) {
      print('Error with client: $error');
      _sockets.remove(clientSocket);
    }, onDone: () {
      print(
          'Client disconnected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
      _sockets.remove(clientSocket);
    });
  }

  void _sendMessageToAll(String message, Socket senderSocket) {
    for (var socket in _sockets) {
      if (socket != senderSocket) {
        socket.write(message);
      }
    }
  }

  void close() {
    _serverSocket?.close();
    for (var socket in _sockets) {
      socket.destroy();
    }
  }
}
