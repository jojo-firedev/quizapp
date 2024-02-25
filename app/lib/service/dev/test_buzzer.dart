import 'package:quizapp/service/buzzer_service.dart';

void testBuzzer() {
  BuzzerService buzzerService = BuzzerService();

  buzzerService.sendConfigWithIP();
}
