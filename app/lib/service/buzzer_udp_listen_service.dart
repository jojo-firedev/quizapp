import 'dart:io';

class UDPListener {
  RawDatagramSocket? _socket;
  final int buzzerUdpPort = 8090;
  final int localUdpPort = 8084;

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
            print('Received message: $message');
          }
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void stopListening() {
    _socket?.close();
  }
}

void main() {
  UDPListener udpListener = UDPListener();
  udpListener.startListening();
}
