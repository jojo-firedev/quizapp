import 'dart:convert';
import 'package:quizapp/globals.dart';
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
    Global.logger.d('Sent udp message: $message');
  }

  void sendConfig() async {
    String ipAddress = await _networkService.getIpAddress();

    String configMessage = jsonEncode({
      "Config": {"ServerIPAdresse": ipAddress}
    });

    Global.logger.d('Config: $configMessage');

    _sendUdpMessage(configMessage);
  }

  void sendBuzzerLock({String? winnerMac}) {
    List winner = [];
    if (winnerMac != null) {
      winner = [winnerMac];
    }
    String lockMessage = jsonEncode({'ButtonLock': winner});

    _sendUdpMessage(lockMessage);
  }

  void sendBuzzerRelease() {
    String releaseMessage = jsonEncode({'ButtonRelease': []});

    _sendUdpMessage(releaseMessage);
  }

  void sendPing() {
    String pingMessage = '["Ping"]';

    _sendUdpMessage(pingMessage);
  }
}
