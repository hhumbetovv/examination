import 'package:examination/exam_view.dart';
import 'package:examination/question.dart';
import 'package:flutter/material.dart';

abstract class ExamModal extends State<Exam> {
  List<Question> questions = Question.questions()..shuffle();
  int currentIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isAnswered = false;

  void onAnswered() {
    setState(() {
      isAnswered = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        isAnswered = false;
      });
    });
  }

  void reset() {
    setState(() {
      questions = questions..shuffle();
      currentIndex = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
    });
  }

  void increaseIndex() {
    if (questions.length - 1 >= currentIndex + 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void increaseCorrectAnswers() {
    setState(() {
      correctAnswers++;
    });
  }

  void increaseWrongAnswers() {
    setState(() {
      wrongAnswers++;
    });
  }
}
