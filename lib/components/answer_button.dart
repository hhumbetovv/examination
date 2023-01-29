import 'package:examination/constants.dart';
import 'package:examination/model/question.dart';
import 'package:examination/model/question_controller.dart';
import 'package:flutter/material.dart';

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
  Align answerText(BuildContext context) {
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

  void buttonOnTap() async {
    setState(() {
      widget.controller.getCurrentQuestion.setIsAnswered();
      widget.currentAnswer.setIsAnswered();
      if (widget.currentAnswer.isCorrectAnswer == true) {
        widget.updateQuestion != null ? widget.updateQuestion!(true) : null;
      } else {
        widget.updateQuestion != null ? widget.updateQuestion!(false) : null;
        widget.controller.setIncorrectAnsweredQuestion();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Color get getColor {
    if (widget.isLearning && widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (!widget.controller.getCurrentQuestion.isAnswered) return Constants.answerColor;
    if (widget.currentAnswer.isCorrectAnswer) return Colors.green;
    if (widget.currentAnswer.isAnswered) return Colors.red;
    return Constants.answerColor;
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
            child: answerText(context),
          ),
        ),
      ),
    );
  }
}
