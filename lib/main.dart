import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_quiz/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('total_mark', 0);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Quiz'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              TextField(
                cursorColor: Colors.green,
                cursorWidth: 5,
                controller: _controller,
                textDirection: TextDirection.ltr,
                style: TextStyle(color: Colors.green),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (_controller.text.length > 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MainPage(
                                    name: _controller.text,
                                  )));
                        } else {
                          showDialog<void>(
                            context: context,
                            //barrierDismissible: barrierDismissible,
                            // false = user must tap button, true = tap outside dialog
                            child: new AlertDialog(
                              title: new Text("Enter Valid Name to proceed"),
                              backgroundColor: Colors.redAccent,
                              //content: new Text(".."),
                            ),
                          );
                        }
                      },
                      child: Text('Start Quiz')),
                ),
              ),
            ],
          ),
        )
        //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}
