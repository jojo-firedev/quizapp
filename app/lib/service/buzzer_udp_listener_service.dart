import 'dart:io';

import 'package:quizapp/globals.dart';
import 'package:quizapp/service/buzzer_manager_service.dart';

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
            BuzzerManagerService(BuzzerType.silent).handleMessage(
              result.data,
              result.address,
              result.port,
            );
            // Process received data here
            // String message = String.fromCharCodes(result.data);
            // Global.logger.d('Received message: $message');
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
