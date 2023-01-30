import 'package:examination/components/dialogs/finish_dialog.dart';
import 'package:examination/model/result_controller.dart';
import 'package:examination/pages/result_view.dart';
import 'package:flutter/material.dart';

import '../components/dialogs/settings_dialog.dart';
import '../model/question_controller.dart';
import 'exam_view.dart';

abstract class ExamModal extends State<ExamView> {
  late final QuestionController controller;
  bool isLoading = false;
  final events = [];
  bool singleTap = true;

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

  void onFinishButtonPressed() async {
    ResultController currentController = controller.resultController.finalResults;
    final result = controller.resultController.blanks != 0
        ? await finishDialog(
            context,
            'There are ${controller.resultController.blanks} more questions you haven\'t answered, are you sure you want to continue?',
          )
        : true;
    if ((result ?? false) && mounted) {
      setIsLoading(value: true);
      setState(() {
        resetQuestions();
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultView(
            controller: currentController,
          ),
        ),
      );
    }
    setIsLoading(value: false);
  }
}
