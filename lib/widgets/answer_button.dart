import 'package:flutter/material.dart';

import '../model/question.dart';
import '../model/question_controller.dart';
import '../utils/constants.dart';

typedef BoolCallback = void Function(bool value);

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    Key? key,
    required this.currentAnswer,
    this.controller,
    this.isLearning = false,
    this.singleTap,
    this.updateQuestion,
  }) : super(key: key);

  final QuestionController? controller;
  final Answer currentAnswer;
  final bool isLearning;
  final bool? singleTap;

  final BoolCallback? updateQuestion;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  late Color buttonColor;

  void buttonOnTap() async {
    setState(() {
      widget.controller!.getCurrentQuestion.setIsAnswered();
      widget.currentAnswer.setIsAnswered();
      if (widget.updateQuestion != null) {
        widget.updateQuestion!(widget.currentAnswer.isCorrectAnswer);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color get getColor {
    if (widget.isLearning && widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (widget.isLearning && widget.currentAnswer.isAnswered) return Colors.red;
    if (!widget.isLearning && !widget.controller!.getCurrentQuestion.isAnswered) {
      return Theme.of(context).colorScheme.primary;
    }
    if (widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (widget.currentAnswer.isAnswered) return Colors.red;
    return Theme.of(context).colorScheme.primary;
  }

  //! Answer Text
  Align get answerText {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.currentAnswer.answer,
        style: const TextStyle(
          fontSize: Constants.fontSizeLarge,
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
        child: InkWell(
          onTap: (widget.singleTap ?? true) && !widget.isLearning && !widget.controller!.getCurrentQuestion.isAnswered
              ? buttonOnTap
              : null,
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
