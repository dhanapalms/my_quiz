import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:my_quiz/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:connectivity/connectivity.dart';

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
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    print('_connectionStatus $_connectionStatus');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

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
                  hintText: 'Enter your name',
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
