import 'package:flutter/material.dart';
import 'package:proj_02/models/quiz_answer.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:proj_02/question_summary/question_identifier.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem(this.data, {super.key});

  final QuizAnswer data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionIdentifier(
              data.questionIndex, data.correctAnswer == data.userAnswer),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            //Expanded restricted the 'width' of its child(Column) only fill up the 'width' of Expanded's parent(Row -> maximum screen width) not take infinity width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.question,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.userAnswer,
                  style: GoogleFonts.lato(
                    color: Colors.purple[300],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.correctAnswer,
                  style: GoogleFonts.lato(
                    color: Colors.blue[200],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
