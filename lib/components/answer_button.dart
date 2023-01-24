import 'package:examination/constants.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool value);

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    Key? key,
    required this.answer,
    this.isCorrectAnswer = false,
    this.isLearning = false,
    this.updateQuestion,
    this.duration,
    this.isAnswered,
  }) : super(key: key);

  final String answer;
  final bool? isCorrectAnswer;
  final bool? isAnswered;
  final bool isLearning;
  final Duration? duration;

  final BoolCallback? updateQuestion;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  Color buttonColor = Constants.answerColor;
  Align answerText(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.answer,
        style: Theme.of(context).textTheme.button?.copyWith(fontSize: Constants.fontSizeLarge),
      ),
    );
  }

  void buttonOnTap() async {
    setState(() {
      if (widget.isCorrectAnswer == true) {
        buttonColor = Colors.green;
        widget.updateQuestion != null ? widget.updateQuestion!(true) : null;
      } else {
        buttonColor = Colors.red;
        widget.updateQuestion != null ? widget.updateQuestion!(false) : null;
      }
    });

    await Future.delayed(widget.duration ?? Duration.zero, () {
      buttonColor = Constants.answerColor;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(1.0),
        child: InkWell(
          onTap: !widget.isLearning ? buttonOnTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ((widget.isAnswered ?? false) && widget.isCorrectAnswer == true) ||
                      (widget.isLearning && widget.isCorrectAnswer == true)
                  ? Colors.green
                  : buttonColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: answerText(context),
          ),
        ),
      ),
    );
  }
}
