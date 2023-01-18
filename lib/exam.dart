import 'package:examination/answer_button.dart';
import 'package:examination/question.dart';
import 'package:examination/select_range_dialog.dart';
import 'package:flutter/material.dart';

class Exam extends StatefulWidget {
  const Exam({
    Key? key,
    required this.title,
    required this.subject,
  }) : super(key: key);

  final String title;
  final String subject;

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  List<Question> allQuestions = [];
  List<Question> questions = [];
  Map<String, int> questionRange = {
    "firstValue": 0,
    "secondValue": 0,
  };
  int currentIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    allQuestions = Question.questions(widget.subject);
    questionRange["secondValue"] = allQuestions.length - 1;
    questions = allQuestions.sublist(0)..shuffle();
  }

  void onAnswered() {
    setState(() {
      isAnswered = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        isAnswered = false;
      });
    });
  }

  void resetQuestions() {
    questions = allQuestions.sublist(questionRange["firstValue"]!, questionRange["secondValue"]! + 1)..shuffle();
    setState(() {
      currentIndex = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
    });
  }

  void reset(BuildContext context) async {
    var result = await selectRangeDialog(context, allQuestions.length, questionRange);
    if (result != null) {
      questionRange = result;
      resetQuestions();
    }
  }

  void increaseIndex({correct = false}) {
    if (questions.length - 1 >= currentIndex + 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      resetQuestions();
    }
  }

  void increaseAnswerCount({correct = false}) {
    setState(() {
      correct ? correctAnswers++ : wrongAnswers++;
    });
  }

  IconButton get resetButton {
    return IconButton(
      onPressed: () {
        setState(() {
          reset(context);
        });
      },
      icon: const Icon(
        Icons.settings_backup_restore_sharp,
      ),
    );
  }

  Align get question {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        questions[currentIndex].question,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Expanded get answers {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: questions[currentIndex].answers.map((item) {
          return AnswerButton(
            answer: item.answer,
            isCurrentAnswer: item.isCurrentAnswer,
            increaseIndex: increaseIndex,
            increaseAnswerCount: (value) => increaseAnswerCount(correct: value),
            isAnswered: isAnswered,
            onAnswered: onAnswered,
          );
        }).toList(),
      ),
    );
  }

  RichText answerCount({bool correct = false}) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              correct ? Icons.check_box_outlined : Icons.clear_outlined,
              color: correct ? Colors.green : Colors.red,
            ),
          ),
          WidgetSpan(
            child: Text(
              '${correct ? correctAnswers : wrongAnswers}',
              style: const TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [resetButton],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            question,
            answers,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                answerCount(),
                Text('${currentIndex + 1} / ${questions.length}'),
                answerCount(correct: true),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
