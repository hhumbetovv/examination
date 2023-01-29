import 'package:flutter/material.dart';

import '../components/settings_dialog.dart';
import '../model/question_controller.dart';
import 'exam_view.dart';

abstract class ExamModal extends State<ExamView> {
  late final QuestionController controller;
  bool isLoading = false;

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

  void setIsLoading({bool value = false}) async {
    if (value == false) {
      await Future.delayed(const Duration(seconds: 1), () {
        isLoading = value;
      });
    } else {
      isLoading = value;
    }
    setState(() {});
  }

  void resetQuestions() {
    setState(() {
      controller.resetValues();
    });
  }

  void updateSettings(BuildContext context) async {
    final result = await settingsDialog(context, controller);
    if (result != null && result) {
      resetQuestions();
    }
  }

  void updateQuestion({bool isCorrect = false}) async {
    setState(() {
      controller.getCurrentQuestion.setIsAnswered();
      controller.resultController.updateResult(question: controller.getCurrentQuestion, isCorrect: isCorrect);
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
