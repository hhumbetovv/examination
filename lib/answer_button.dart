import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool value);

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.answer,
    this.isCurrentAnswer = false,
    required this.increaseIndex,
    required this.isAnswered,
    required this.onAnswered,
    required this.increaseAnswerCount,
  });

  final String answer;
  final bool? isCurrentAnswer;
  final bool isAnswered;

  final VoidCallback onAnswered;
  final VoidCallback increaseIndex;
  final BoolCallback increaseAnswerCount;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool isChecked = false;
  Color buttonColor = Colors.blue;
  bool longPress = false;

  Padding get answerText {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.answer,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isAnswered,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          onLongPress: () {
            setState(() {
              longPress = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isAnswered && widget.isCurrentAnswer == true ? Colors.green : buttonColor,
          ),
          onPressed: longPress || widget.isAnswered
              ? null
              : () async {
                  setState(() {
                    if (widget.isCurrentAnswer == true) {
                      buttonColor = Colors.green;
                      widget.increaseAnswerCount(true);
                    } else {
                      buttonColor = Colors.red;
                      widget.increaseAnswerCount(false);
                    }
                  });
                  widget.onAnswered();

                  await Future.delayed(const Duration(milliseconds: 1500), () {
                    buttonColor = Colors.blue;
                    widget.increaseIndex();
                    setState(() {});
                  });
                },
          child: answerText,
        ),
      ),
    );
  }
}
