import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:my_quiz/screens/options_page.dart';

class QuizPage extends StatefulWidget {
  final List<Questions> listQuestions;
  final PageController controller;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Option> onClickedOption;

  const QuizPage(
      {Key key,
      this.listQuestions,
      this.controller,
      this.onChangedPage,
      this.onClickedOption})
      : super(key: key);
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
//        appBar: AppBar(),
          body: PageView.builder(
        onPageChanged: widget.onChangedPage,
        controller: widget.controller,
        itemCount: widget.listQuestions.length,
        itemBuilder: (context, index) {
          final question = widget.listQuestions[index];
          return buildQuestion(question: question);
        },
      ));

  Widget buildQuestion({@required Questions question}) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Text(
              question.text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(
              height: 8,
            ),
            Text('Choose your answer from below'),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: OptionsPage(
                    question: question,
                    onClickedOption: widget.onClickedOption)),
          ],
        ),
      );
}
