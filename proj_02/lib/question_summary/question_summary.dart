import 'package:flutter/material.dart';
import 'package:proj_02/models/quiz_answer.dart';
import 'package:proj_02/question_summary/summary_item.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary(this.summaryData, {super.key});

  final List<QuizAnswer> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) => SummaryItem(data)).toList(),
        ),
      ),
    );
  }
}
