import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:my_quiz/screens/home_page.dart';

class MainPage extends StatefulWidget {
  final String name;

  const MainPage({Key key, this.name}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Questions> listQuestions;

  @override
  void initState() {
    listQuestions = [];
    super.initState();
    fetchQuestionFromFireStore();
    print('listQuestions - $listQuestions ${listQuestions.length}');
    //question = listQuestions[0];
    //print('listQuestions.first ${listQuestions.first}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (listQuestions != null)
            ? (listQuestions.isNotEmpty)
                ? HomePage(
                    questions: listQuestions,
                    name: widget.name,
                  )
                : Center(child: CircularProgressIndicator())
            : Center(child: Text('Quiz not started yet')));
  }

  void fetchQuestionFromFireStore() async {
    Map<String, dynamic> d = {"solution": "data"};

    var box = await Hive.openBox('marks');
    print(d);
    await firestoreInstance
        .collection("computer_science")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Questions q = new Questions();

        List temp;
        // print('Result');
        // print(result.data()["solution"]);
        q.solution = result.data()["solution"];
        //print('q.solution - ${q.solution}');
        q.text = result.data()["text"];
        box.put(result.data()["text"], 0);

        //print('q.text - ${q.text}');
        temp = result.data()["option"];

        List<Option> op = List<Option>();
        temp.forEach((element) {
          Option o = new Option();
          o.code = element["code"];
          o.text = element["text"];
          o.isCorrect = element["isCorrect"];
          op.add(o);
        });
        q.option = op;
        // print('q.option - ${q.option}');
        // print('q - $q');

        listQuestions.add(q);
        // print(
        //     'Questions.fromJson(result.data()) ${Questions.fromJson(result.data())}');
      });
    });
    setState(() {});
  }
}
