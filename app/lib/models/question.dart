class Question {
  final String question;
  final String correctAnswer;
  bool isAnswered;

  Question(this.question, this.correctAnswer, {this.isAnswered = false});
}
