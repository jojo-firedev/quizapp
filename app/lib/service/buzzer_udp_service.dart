import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

import 'package:quizapp/service/network_service.dart';

class BuzzerUdpService {
  final NetworkService _networkService = NetworkService();
  final Port buzzerUdpConfigPort = const Port(8090);

  void sendUdpMessage(String message) async {
    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    await sender.send(
        message.codeUnits, Endpoint.broadcast(port: buzzerUdpConfigPort));
    print('Sent config message');
  }

  void sendConfigWithIP() async {
    String ipAddress = await _networkService.getIpAddress();
    const String broadcastAddress = '255.255.255.255'; // Broadcast address
    const int port = 4444; // Port number

    String configMessage =
        '''{"Config": {"ServerIPAdresse": "192.168.0.120"}}''';
    print('Config: $configMessage');

    List<int> data = utf8.encode(configMessage);

    var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    var result = socket.send(data, InternetAddress(broadcastAddress), port);

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    await sender.send(data, Endpoint.broadcast(port: buzzerUdpConfigPort));
    print('Sent config message ${result}');

    sendUdpMessage(configMessage);
    print('Sent config message');
  }

  void sendButtonLock() {
    String lockMessage = jsonEncode({'ButtonLock': []});

    sendUdpMessage(lockMessage);
  }

  void sendButtonRelease() {
    String releaseMessage = jsonEncode({'ButtonRelease': []});

    sendUdpMessage(releaseMessage);
  }
}
