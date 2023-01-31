import 'package:flutter/material.dart';

import '../model/question_controller.dart';
import '../widgets/dialogs/settings_dialog.dart';
import 'learning_view.dart';

abstract class LearningModal extends State<LearningView> {
  late final QuestionController controller;
  String swipeDirection = 'zero';

  @override
  void initState() {
    super.initState();
    controller = QuestionController(bank: widget.subject.bank);
    controller.initialize(isLearning: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateSettings(BuildContext context) async {
    final result = await settingsDialog(context, controller);
    if (result ?? false) {
      setState(() {
        controller.resetValues();
      });
    }
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
