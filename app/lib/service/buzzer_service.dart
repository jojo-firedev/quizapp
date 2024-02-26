import 'package:udp/udp.dart';

import 'package:quizapp/service/network_service.dart';

class BuzzerService {
  final NetworkService _networkService = NetworkService();
  final Port buzzerUdpConfigPort = const Port(8090);

  void sendConfigWithIP() async {
    String ipAddress = await _networkService.getIpAddress();

    String configMessage = '{"Config": {"ServerIPAdresse" : "$ipAddress"}}';
    print('Config: $configMessage');

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    await sender.send(
        configMessage.codeUnits, Endpoint.broadcast(port: buzzerUdpConfigPort));
    print('Sent config message');
  }
}
