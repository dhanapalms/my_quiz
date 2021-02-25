import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:my_quiz/screens/quiz_page.dart';
import 'package:my_quiz/widgets/QuestionNumbersWidget.dart';
import 'package:my_quiz/screens/submit_page.dart';

class HomePage extends StatefulWidget {
  final List<Questions> questions;
  final String name;

  const HomePage({Key key, this.questions, this.name}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller;
  Questions question;
  Map<String, dynamic> answered;
  int count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
    controller = PageController();
    question = widget.questions.first;
    print('question $question');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('My Quiz'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Welcome ${widget.name}'),
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrangeAccent, Colors.purple])),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: QuestionNumbersWidget(
                  questions: widget.questions,
                  question: question,
                  onClickedNumber: (index) =>
                      nextQuestion(index: index, jump: true)),
            ),
          ),
        ),
        body: QuizPage(
          listQuestions: widget.questions,
          controller: controller,
          onChangedPage: (index) => nextQuestion(index: index),
          onClickedOption: selectOption,
        ),
        bottomNavigationBar:
            // (count == widget.questions.length) ? Text('bottom') : Text(''),
            (count == widget.questions.length)
                ? RaisedButton(
                    child: Text('Submit'),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SubmitPage(
                                    length: widget.questions.length,
                                  )));
                    },
                  )
                : Text(''),
      );

  void selectOption(Option value) {
    if (question.isLocked == true) {
      return;
    } else {
      setState(() {
        question.isLocked = true;
        question.selectedOption = value;
        //answered.addAll({value.code: value.text});
        //print('answered $answered');
        count++;
        print('count $count');
      });
    }
  }

  nextQuestion({int index, bool jump = false}) {
    final nextPage = controller.page + 1;
    final indexPage = index ?? nextPage.toInt();
    setState(() {
      question = widget.questions[indexPage];
    });
    if (jump) {
      controller.jumpToPage(indexPage);
    }
  }
}
