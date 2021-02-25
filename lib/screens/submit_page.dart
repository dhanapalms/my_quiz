import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SubmitPage extends StatefulWidget {
  final int length;

  const SubmitPage({Key key, this.length}) : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  int t = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.yellowAccent,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Completed',
              style: TextStyle(fontSize: 20.0),
            ),
            Icon(
              Icons.check_circle_sharp,
              color: Colors.green,
              size: 150,
            ),
            Text(
              ' Mark :- $t / ${widget.length}',
              style: TextStyle(fontSize: 35.0),
            )
          ],
        )),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        child: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void fetchMarks() async {
    var box = await Hive.openBox('marks');
    box.values.forEach((element) {
      t += element;
      print('ele - $element - $t');
    });
    setState(() {});
  }
}
