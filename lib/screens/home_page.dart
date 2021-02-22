import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:my_quiz/screens/quiz_page.dart';

class HomePage extends StatefulWidget {
  final List<Questions> questions;

  const HomePage({Key key, this.questions}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller;
  Questions question;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController();
    question = widget.questions.first;
    print('question $question');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: QuizPage(
          listQuestions: widget.questions,
          controller: controller,
          onChangedPage: (index) => nextQuestion(index: index),
          onClickedOption: selectOption,
        ),
      );

  void selectOption(Option value) {
    if (question.isLocked == true) {
      return;
    } else {
      setState(() {
        question.isLocked = true;
        question.selectedOption = value;
      });
    }
  }

  nextQuestion({int index}) {
    final nextPage = controller.page + 1;
    final indexPage = index ?? nextPage.toInt();
    setState(() {
      question = widget.questions[indexPage];
    });
  }
}
