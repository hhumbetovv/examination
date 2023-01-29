import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/question.dart';
import '../model/question_controller.dart';

typedef BoolCallback = void Function(bool value);

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    Key? key,
    required this.currentAnswer,
    required this.controller,
    this.isLearning = false,
    this.updateQuestion,
  }) : super(key: key);

  final QuestionController controller;
  final Answer currentAnswer;
  final bool isLearning;

  final BoolCallback? updateQuestion;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  late Color buttonColor;

  void buttonOnTap() async {
    setState(() {
      widget.controller.getCurrentQuestion.setIsAnswered();
      widget.currentAnswer.setIsAnswered();
      if (widget.updateQuestion != null) {
        widget.updateQuestion!(widget.currentAnswer.isCorrectAnswer);
      }
      if (widget.currentAnswer.isCorrectAnswer) widget.controller.setIncorrectQuestion();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color get getColor {
    if (widget.isLearning && widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (!widget.controller.getCurrentQuestion.isAnswered) return Constants.accentColor;
    if (widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (widget.currentAnswer.isAnswered) return Colors.red;
    return Constants.accentColor;
  }

  //! Answer Text
  Align get answerText {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.currentAnswer.answer,
        style: const TextStyle(
          fontSize: Constants.fontSizeLarge,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: Constants.radiusSmall,
        color: Colors.white.withOpacity(1.0),
        child: InkWell(
          onTap: !widget.isLearning && !widget.controller.getCurrentQuestion.isAnswered ? buttonOnTap : null,
          borderRadius: Constants.radiusSmall,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: Constants.radiusSmall,
              color: getColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: answerText,
          ),
        ),
      ),
    );
  }
}
