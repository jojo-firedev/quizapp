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
    // Start the Flutter app
    String appPath =
        '../screen_app/build/linux/arm64/release/bundle/quizapp_screen';
    await Process.start(appPath, []);

    // // Wait a few seconds for the app to launch
    // await Future.delayed(Duration(seconds: 3));

    // // Get monitor info from xrandr
    // ProcessResult result = await Process.run('xrandr', ['--listmonitors']);
    // String xrandrOutput = result.stdout;

    // // Find the monitor with index 0
    // List<String> lines = xrandrOutput.split('\n');
    // String monitor0 = '';
    // for (String line in lines) {
    //   if (line.startsWith(' 0:')) {
    //     // This is the monitor at index 0
    //     monitor0 = line;
    //     break;
    //   }
    // }

    // if (monitor0.isNotEmpty) {
    //   // Extract the position of the monitor
    //   // Example line: " 0: +XWAYLAND0 1920/530x1080/300+0+0  XWAYLAND0"
    //   // We need the position: "+0+0" means (x: 0, y: 0)
    //   RegExp positionPattern = RegExp(r'\+(\d+)\+(\d+)');
    //   RegExpMatch? match = positionPattern.firstMatch(monitor0);
    //   if (match != null) {
    //     String xPos = match.group(1) ?? '0';
    //     String yPos = match.group(2) ?? '0';

    //     // Use wmctrl to move the app to the correct monitor (index 0)
    //     String moveWindowCommand = 'wmctrl -r :ACTIVE: -e 0,$xPos,$yPos,-1,-1';
    //     await Process.run('bash', ['-c', moveWindowCommand]);
    //     print(
    //         'App launched and moved to monitor at position $xPos, $yPos (index 0).');
    //   } else {
    //     print('Could not extract position from xrandr output.');
    //   }
    // } else {
    //   print('Monitor index 0 not found.');
    // }
  }
}
