import 'package:examination/exam_modal.dart';
import 'package:flutter/material.dart';

class Exam extends StatefulWidget {
  const Exam({
    Key? key,
  }) : super(key: key);

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends ExamModal {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Şəbəkə Təhlükəsizliyi - ${allQuestions.length}',
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                reset(context);
              });
            },
            icon: const Icon(
              Icons.restore_outlined,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                questions[currentIndex].question,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: questions[currentIndex].answers.map((item) {
                  return AnswerButton(
                    answer: item.answer,
                    isCurrentAnswer: item.isCurrentAnswer,
                    increaseIndex: increaseIndex,
                    increaseCorrectAnswers: increaseCorrectAnswers,
                    increaseWrongAnswers: increaseWrongAnswers,
                    isAnswered: isAnswered,
                    onAnswered: onAnswered,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.clear_outlined,
                          color: Colors.red,
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '$wrongAnswers',
                          style: const TextStyle(fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
                Text('${currentIndex + 1} / ${questions.length}'),
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.check_box_outlined,
                          color: Colors.green,
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '$correctAnswers',
                          style: const TextStyle(fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.answer,
    this.isCurrentAnswer = false,
    required this.increaseIndex,
    required this.isAnswered,
    required this.onAnswered,
    required this.increaseCorrectAnswers,
    required this.increaseWrongAnswers,
  });

  final String answer;
  final bool? isCurrentAnswer;
  final bool isAnswered;

  final VoidCallback onAnswered;
  final VoidCallback increaseIndex;
  final VoidCallback increaseCorrectAnswers;
  final VoidCallback increaseWrongAnswers;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool isChecked = false;
  Color buttonColor = Colors.blue;
  bool longPress = false;
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
              backgroundColor: widget.isAnswered && widget.isCurrentAnswer == true ? Colors.green : buttonColor),
          onPressed: longPress || widget.isAnswered
              ? null
              : () async {
                  setState(() {
                    if (widget.isCurrentAnswer == true) {
                      buttonColor = Colors.green;
                      widget.increaseCorrectAnswers();
                    } else {
                      buttonColor = Colors.red;
                      widget.increaseWrongAnswers();
                    }
                  });
                  widget.onAnswered();

                  await Future.delayed(const Duration(milliseconds: 1500), () {
                    buttonColor = Colors.blue;
                    widget.increaseIndex();
                    setState(() {});
                  });
                },
          child: Padding(
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
          ),
        ),
      ),
    );
  }
}
