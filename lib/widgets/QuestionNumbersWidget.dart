import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';

class QuestionNumbersWidget extends StatelessWidget {
  final List<Questions> questions;
  final Questions question;
  final ValueChanged<int> onClickedNumber;

  const QuestionNumbersWidget(
      {Key key, this.questions, this.question, this.onClickedNumber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double padding = 16;
    return Container(
      height: 50,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: padding),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Container(
          width: padding,
        ),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final isSelected = question == questions[index];
          return buildNumber(index: index, isSelected: isSelected);
        },
      ),
    );
  }

  Widget buildNumber({int index, bool isSelected}) {
    final color = isSelected ? Colors.orange : Colors.white;
    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
