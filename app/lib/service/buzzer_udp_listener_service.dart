import 'dart:io';

import 'package:quizapp/globals.dart';

class BuzzerUdpListener {
  RawDatagramSocket? _socket;
  final int buzzerUdpPort = 8090;
  final int localUdpPort = 8084;

  BuzzerUdpListener() {
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
          Datagram? datagram = _socket!.receive();
          if (datagram != null) {
            // Process received data here
            String message = String.fromCharCodes(datagram.data);
            Global.logger.d('Received message: $message');
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
