import 'package:udp/udp.dart';

import 'package:quizapp/service/network_service.dart';

class BuzzerService {
  final NetworkService _networkService = NetworkService();

  void sendConfigWithIP() async {
    String ipAddress = await _networkService.getIpAddress();
    print('IP: $ipAddress');

    String configMessage = '{"Config": {"ServerIPAdresse" : "$ipAddress"}}';
    print('Config: $configMessage');
    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send(
        configMessage.codeUnits, Endpoint.broadcast(port: const Port(8090)));
    print('Sent $dataLength bytes');
  }
}
