import 'package:flutter/material.dart';

class Questions {
  String solution;
  String text;
  List<Option> option;
  bool isLocked;
  Option selectedOption;

  Questions(
      {@required this.solution,
      @required this.text,
      @required this.option,
      this.isLocked,
      this.selectedOption});

  Questions.fromJson(Map<String, dynamic> json) {
    solution = json['solution'];
    text = json['text'];
    if (json['option'] != null) {
      option = new List<Option>();
      json['option'].forEach((v) {
        option.add(new Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['solution'] = this.solution;
    data['text'] = this.text;
    if (this.option != null) {
      data['option'] = this.option.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  String code;
  String text;
  bool isCorrect;

  Option({this.code, this.text, this.isCorrect});

  Option.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    text = json['text'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['text'] = this.text;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}
