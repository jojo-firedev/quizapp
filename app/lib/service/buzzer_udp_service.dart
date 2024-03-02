import 'dart:convert';
import 'package:udp/udp.dart';

import 'package:quizapp/service/network_service.dart';

class BuzzerUdpService {
  final NetworkService _networkService = NetworkService();
  final Port _buzzerUdpPort = const Port(8090);
  final Port _localUdpPort = const Port(8084);

  void _sendUdpMessage(String message) async {
    List<int> data = utf8.encode(message);
    var sender = await UDP.bind(Endpoint.any(port: _localUdpPort));
    await sender.send(data, Endpoint.broadcast(port: _buzzerUdpPort));
    print('Sent config message');
  }

  void sendConfigWithIP() async {
    String ipAddress = await _networkService.getIpAddress();

    String configMessage = jsonEncode({
      "Config": {"ServerIPAdresse": ipAddress}
    });

    print('Config: $configMessage');

    _sendUdpMessage(configMessage);
  }

  void sendButtonLock() {
    String lockMessage = jsonEncode({'ButtonLock': []});

    _sendUdpMessage(lockMessage);
  }

  void sendButtonRelease() {
    String releaseMessage = jsonEncode({'ButtonRelease': []});

    _sendUdpMessage(releaseMessage);
  }

  void sendPing() {
    String pingMessage = jsonEncode({
      'Ping': ["Ping"]
    });

    _sendUdpMessage(pingMessage);
  }
}
