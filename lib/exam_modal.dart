import 'package:examination/exam_view.dart';
import 'package:examination/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ExamModal extends State<Exam> {
  List<Question> allQuestions = Question.questions();
  List<Question> questions = [];
  Map<String, int> questionRange = {
    "firstValue": 0,
    "secondValue": 0,
  };
  int currentIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isAnswered = false;

  void onAnswered() {
    setState(() {
      isAnswered = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        isAnswered = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    questionRange["secondValue"] = allQuestions.length - 1;
    questions = allQuestions.sublist(0)..shuffle();
  }

  Future<Map<String, int>?> selectRangeDialog(
      BuildContext context, int rangeLength, Map<String, int> currentRange) async {
    return showDialog<Map<String, int>>(
      context: context,
      builder: ((context) {
        Map<String, int> newRange = currentRange;
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty && int.parse(value) < rangeLength - 1) {
                      newRange["firstValue"] = int.parse(value) - 1;
                    }
                    if (value.isEmpty) {
                      newRange["firstValue"] = 0;
                    }
                    if (value.isNotEmpty && int.parse(value) >= rangeLength - 1) {
                      newRange["firstValue"] = newRange["secondValue"]! - 1;
                    }
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "${currentRange["firstValue"]! + 1}",
                    contentPadding: const EdgeInsets.only(
                      bottom: 25,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const Text(
                ' - ',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty && int.parse(value) < rangeLength - 1) {
                      newRange["secondValue"] = int.parse(value) - 1;
                    }
                    if (value.isEmpty) {
                      newRange["secondValue"] = 0;
                    }
                    if (value.isNotEmpty && int.parse(value) >= rangeLength - 1) {
                      newRange["secondValue"] = rangeLength - 1;
                    }
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "${currentRange["secondValue"]! + 1}",
                    contentPadding: const EdgeInsets.only(
                      bottom: 25,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(currentRange);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('CANCEL'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(newRange);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('OK'),
              ),
            )
          ],
        );
      }),
    );
  }

  void reset(BuildContext context) async {
    var result = await selectRangeDialog(context, allQuestions.length, questionRange);
    questionRange = result!;
    questions = allQuestions.sublist(questionRange["firstValue"]!, questionRange["secondValue"]! + 1)..shuffle();
    setState(() {
      currentIndex = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
    });
  }

  void increaseIndex() {
    if (questions.length - 1 >= currentIndex + 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void increaseCorrectAnswers() {
    setState(() {
      correctAnswers++;
    });
  }

  void increaseWrongAnswers() {
    setState(() {
      wrongAnswers++;
    });
  }
}
