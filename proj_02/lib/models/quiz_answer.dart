class QuizAnswer {
  const QuizAnswer(
    this.questionIndex,
    this.question,
    this.correctAnswer,
    this.userAnswer,
  );

  final int questionIndex;
  final String question;
  final String correctAnswer;
  final String userAnswer;
}
