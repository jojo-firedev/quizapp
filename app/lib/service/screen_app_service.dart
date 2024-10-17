import 'dart:convert';
import 'dart:io';

class ScreenAppService {
  ServerSocket? _serverSocket;
  Socket? _connectedSocket;
  final int port;
  Function(String)? onStatusChange;

  ScreenAppService({this.port = 4040, this.onStatusChange});

  void startServer() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    _serverSocket?.listen((Socket clientSocket) {
      _connectedSocket = clientSocket;
      _notifyStatusChange('Client connected!');

      clientSocket.listen((data) {
        print('Received data: ${utf8.decode(data)}');
      });
    });
    _notifyStatusChange('Waiting for client connection on port $port...');
  }

  void sendCategories(Map<String, bool> categories) {
    sendData({
      'type': 'categories',
      'categories': categories,
    });
  }

  void sendCategoriesWithFocus(
      Map<String, bool> categories, String selectedCategory) {
    sendData({
      'type': 'categories',
      'categories': categories,
      'selectedCategory': selectedCategory,
    });
  }

  void sendQuestion(String question, String category, String team) {
    sendData({
      'type': 'question',
      'question': question,
      'category': category,
      'jugendfeuerwehr': team,
    });
  }

  void sendCountdown(String question, String category, int countdown) {
    sendData({
      'type': 'countdown',
      'question': question,
      'category': category,
      'countdown': countdown,
    });
  }

  void sendAnswer(
      String question, String answer, String category, String team) {
    sendData({
      'type': 'answer',
      'question': question,
      'answer': answer,
      'category': category,
      'jugendfeuerwehr': team,
    });
  }

  void sendScore(int score) {
    sendData({
      'type': 'score',
      'score': score,
    });
  }

  void sendPointInput(
      List<String> teams, List<int> currentPoints, List<int> inputPoints) {
    sendData({
      'type': 'point_input',
      'jugendfeuerwehren': teams,
      'currentPoints': currentPoints,
      'inputPoints': inputPoints,
    });
  }

  void sendData(Map<String, dynamic> data) {
    if (_connectedSocket != null) {
      String jsonData = jsonEncode(data);
      _connectedSocket?.write(jsonData);
      print('Sent: $jsonData');
    } else {
      print('No client connected!');
    }
  }

  void _notifyStatusChange(String message) {
    if (onStatusChange != null) {
      onStatusChange!(message);
    }
  }

  void closeServer() {
    _serverSocket?.close();
  }

  void startScreenApp() async {
    // Path to the other Flutter app binary
    String appPath =
        '../screen_app/build/linux/arm64/release/bundle/quizapp_screen';

    // Check if the app exists at the specified path
    if (await File(appPath).exists()) {
      try {
        // Launch the app as an external process
        Process result = await Process.start(appPath, []);
        print('Started quizapp_screen with pid: ${result.pid}');
      } catch (e) {
        print('Failed to start quizapp_screen: $e');
      }
    } else {
      print('App not found at path: $appPath');
    }
  }
}
