import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj_02/models/quiz_answer.dart';
import 'package:proj_02/data/questions.dart';
import 'package:proj_02/question_summary/question_summary.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen(
      {super.key, required this.chosenAnswer, required this.restartHandler});

  final List<String> chosenAnswer;
  final void Function() restartHandler;

  List<QuizAnswer> get summaryData {
    final List<QuizAnswer> summary = [];
    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add(QuizAnswer(
        i,
        questions[i].text,
        questions[i].answers[0],
        chosenAnswer[i],
      ));
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData
        .where((data) => data.userAnswer == data.correctAnswer)
        .length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answer $numTotalQuestions out of $numCorrectQuestions questions correctly',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionSummary(summaryData),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: restartHandler,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
            )
          ],
        ),
      ),
    );
  }
}
