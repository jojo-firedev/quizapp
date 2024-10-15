class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  void connect() {
    print('SocketService.connect');
  }

  void disconnect() {
    print('SocketService.disconnect');
  }

  void sendMessage(String message) {
    print('SocketService.sendMessage: $message');
  }
}
