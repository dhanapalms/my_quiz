import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';

class OptionsPage extends StatelessWidget {
  final Questions question;
  final ValueChanged<Option> onClickedOption;

  const OptionsPage({Key key, this.question, this.onClickedOption})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ListView(
        physics: BouncingScrollPhysics(),
        children:
            question.option.map((op) => buildOption(context, op)).toList(),
      );

  Widget buildOption(BuildContext context, Option op) {
    final color = getColorForOption(op, question);
    return GestureDetector(
      onTap: () => onClickedOption(op),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                buildAnswer(op),
                buildSolution(question.selectedOption, op),
              ],
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget buildAnswer(Option op) => Container(
        height: 50,
        child: Row(
          children: [
            Text(
              op.code,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              op.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Color getColorForOption(Option op, Questions question) {
    final isSelected = question.selectedOption == op;
    if (!isSelected) {
      return Colors.grey.shade200;
    } else {
      return op.isCorrect ? Colors.green : Colors.red;
    }
  }

  buildSolution(Option selectedOption, Option op) {
    if (selectedOption == op) {
      return Text(
        question.solution,
        style: TextStyle(
          fontSize: 16,
        ),
      );
    } else {
      return Container();
    }
  }
}
