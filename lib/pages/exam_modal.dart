import 'package:flutter/material.dart';

import '../components/settings_dialog.dart';
import '../model/question_controller.dart';
import 'exam_view.dart';

abstract class ExamModal extends State<ExamView> {
  late final QuestionController controller;

  @override
  void initState() {
    super.initState();
    controller = QuestionController(bank: widget.subject.bank);
    controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetQuestions() {
    setState(() {
      controller.resetValues();
    });
  }

  void updateSettings(BuildContext context) async {
    final result = await settingsDialog(context, controller);
    if (result ?? false) {
      resetQuestions();
    }
  }

  void updateQuestion({bool isCorrect = false}) async {
    setState(() {
      controller.getCurrentQuestion.setIsAnswered();
      controller.updateResults(isCorrect);
    });
  }

  void changeQuestion({bool increase = false}) {
    setState(() {
      if (increase) {
        controller.increaseIndex();
      } else {
        controller.decreaseIndex();
      }
    });
  }
}
