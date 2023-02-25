import 'dart:async';

import 'package:flutter/material.dart';

import '../model/question_controller.dart';
import '../model/result_controller.dart';
import '../widgets/dialogs/finish_dialog.dart';
import '../widgets/dialogs/settings_dialog.dart';
import 'exam_view.dart';
import 'result_view.dart';

abstract class ExamModal extends State<ExamView> {
  late final QuestionController controller;
  bool isLoading = false;
  final events = [];
  bool singleTap = true;

  String swipeDirection = 'zero';

  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = QuestionController(bank: widget.subject.bank);
    controller.initialize();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    setState(() {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountUp());
    });
  }

  void stopTimer() {
    setState(() {
      timer!.cancel();
    });
  }

  void resetTimer() {
    setState(() {
      controller.resultController.setDuration(const Duration(seconds: 0));
    });
  }

  void setCountUp() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = controller.resultController.duration.inSeconds + reduceSecondsBy;
      controller.resultController.setDuration(Duration(seconds: seconds));
    });
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
      resetTimer();
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
    final result = controller.resultController.blanks != 0
        ? await finishDialog(
            context,
            'There are ${controller.resultController.blanks} more questions you haven\'t answered, are you sure you want to continue?',
          )
        : true;
    if ((result ?? false) && mounted) {
      ResultController currentController = controller.resultController.finalResults;
      setIsLoading(value: true);
      setState(() {
        resetQuestions();
        stopTimer();
        resetTimer();
      });
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => ResultView(
                controller: currentController,
              ),
            ),
          )
          .then((_) => startTimer());
    }
    setIsLoading(value: false);
  }
}
