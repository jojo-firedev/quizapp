import 'dart:convert';
import 'dart:io';

import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_udp_service.dart';

class BuzzerUdpListenerService {
  RawDatagramSocket? _socket;
  final int buzzerUdpPort = 8090;
  final int localUdpPort = 8084;

  BuzzerUdpListenerService() {
    startListening();
    Global.logger.d('Buzzer UDP listener started on port $localUdpPort');
  }

  void startListening() async {
    try {
      // Create a new UDP socket
      _socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, localUdpPort);

      // Listen for UDP packets
      _socket!.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? result = _socket!.receive();
          if (result != null) {
            String message = utf8.decode(result.data);
            Map<String, dynamic> jsonObject = jsonDecode(message);

            Global.logger.d(
                'Received message from ${result.address.address}:${result.port}: $message');

            if (jsonObject.values.first == 'Connected') {
              String mac = jsonObject.keys.first;
              if (!Global.macs.contains(mac)) {
                Global.macs.add(mac);
              }
            } else if (jsonObject.values.first == 'ButtonPressed') {
              String mac = jsonObject.keys.first;
              if (!Global.macs.contains(mac)) {
                Global.macs.add(mac);
              }

              BuzzerUdpService().sendBuzzerLock(winnerMac: mac);
            }
          }
        }
      });
    } catch (e) {
      Global.logger.d('Error: $e');
    }
  }

  void stopListening() {
    _socket?.close();
  }
}
