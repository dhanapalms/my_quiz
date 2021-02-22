import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:my_quiz/screens/home_page.dart';
import 'package:my_quiz/screens/quiz_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    final firestoreInstance = FirebaseFirestore.instance;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: (listQuestions != null)
          ? (listQuestions.isNotEmpty)
              ? HomePage(
                  questions: listQuestions,
                )
              : Center(child: CircularProgressIndicator())
          : Center(child: CircularProgressIndicator()),
      //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void fetchQuestionFromFireStore() async {
    Map<String, dynamic> d = {"solution": "data"};

    print(d);
    await firestoreInstance
        .collection("computer_science")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Questions q = new Questions();

        List temp;
        print('Result');
        print(result.data()["solution"]);
        q.solution = result.data()["solution"];
        print('q.solution - ${q.solution}');
        q.text = result.data()["text"];
        print('q.text - ${q.text}');
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
        print('q.option - ${q.option}');
        print('q - $q');

        listQuestions.add(q);
        print(
            'Questions.fromJson(result.data()) ${Questions.fromJson(result.data())}');
      });
    });
  }
}
