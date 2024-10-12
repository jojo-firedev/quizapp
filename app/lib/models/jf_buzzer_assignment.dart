import 'package:quizapp/models/buzzer_assignment.dart';
import 'package:quizapp/models/jugendfeuerwehr.dart';
import 'package:quizapp/models/punkte.dart';

class JfBuzzerAssignment {
  final Jugendfeuerwehr jugendfeuerwehr;
  final BuzzerAssignment buzzerAssignment;
  List<Punkte> punkte = [];

  JfBuzzerAssignment({
    required this.jugendfeuerwehr,
    required this.buzzerAssignment,
  });
}
