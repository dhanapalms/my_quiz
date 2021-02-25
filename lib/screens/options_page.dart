import 'package:flutter/material.dart';
import 'package:my_quiz/model/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class OptionsPage extends StatefulWidget {
  final Questions question;
  final ValueChanged<Option> onClickedOption;

  const OptionsPage({Key key, this.question, this.onClickedOption})
      : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView(
        physics: BouncingScrollPhysics(),
        children: widget.question.option
            .map((op) => buildOption(context, op))
            .toList(),
      );

  Widget buildOption(BuildContext context, Option op) {
    final color = getColorForOption(op, widget.question);

    return GestureDetector(
      onTap: () => widget.onClickedOption(op),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                buildAnswer(op),
                buildSolution(widget.question.selectedOption, op),
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
      if (op.isCorrect) {
        addTotal();
        fetchFromDB();
      }
      return op.isCorrect ? Colors.green : Colors.red;
    }
  }

  buildSolution(Option selectedOption, Option op) {
    if (selectedOption == op) {
      print('total - ');
      return Text(
        widget.question.solution,
        style: TextStyle(
          fontSize: 16,
        ),
      );
    } else {
      return Container();
    }
  }

  void addTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int existing = prefs.getInt('total_mark');
    prefs.setInt('total_mark', existing + 1);
    print(' Total mark - ${prefs.getInt('total_mark')}');
  }

  void fetchFromDB() async {
    var box = await Hive.openBox('marks');

    print('B box - ${box.values}');
    box.put(widget.question.text, 1);
    print('A box - ${box.values}');
  }
}
