import 'dart:convert';

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

    String configMessage = '{"Config": {"ServerIPAdresse" : "$ipAddress"}}';
    print('Config: $configMessage');

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
