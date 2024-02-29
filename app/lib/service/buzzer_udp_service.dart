import 'dart:convert';
import 'package:udp/udp.dart';

import 'package:quizapp/service/network_service.dart';

class BuzzerUdpService {
  final NetworkService _networkService = NetworkService();
  final Port buzzerUdpPort = const Port(8090);
  final Port localUdpPort = const Port(8084);

  void sendUdpMessage(String message) async {
    List<int> data = utf8.encode(message);
    var sender = await UDP.bind(Endpoint.any(port: localUdpPort));
    await sender.send(data, Endpoint.broadcast(port: buzzerUdpPort));
    print('Sent config message');
  }

  void sendConfigWithIP() async {
    String ipAddress = await _networkService.getIpAddress();

    String configMessage = jsonEncode({
      "Config": {"ServerIPAdresse": ipAddress}
    });

    print('Config: $configMessage');

    sendUdpMessage(configMessage);
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
