import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionIdentifier extends StatelessWidget {
  const QuestionIdentifier(this.questionIndex, this.isQuestionCorrect,
      {super.key});

  final int questionIndex;
  final bool isQuestionCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isQuestionCorrect ? Colors.green[200] : Colors.red[200],
        shape: BoxShape.circle,
      ),
      child: Text(
        questionIndex.toString(),
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
