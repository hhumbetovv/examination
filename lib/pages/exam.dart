import 'package:examination/components/answer_button.dart';
import 'package:examination/components/select_range_dialog.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/question.dart';
import 'package:examination/model/subjects.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class Exam extends StatefulWidget {
  const Exam({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

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
  int corrects = 0;
  int wrongs = 0;
  int result = 0;
  Duration duration = const Duration(milliseconds: 1500);
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    allQuestions = Question.questions(widget.subject.blank);
    questionRange["secondValue"] = allQuestions.length - 1;
    questions = allQuestions.sublist(0)..shuffle();
  }

  void resetQuestions() {
    questions = allQuestions.sublist(questionRange["firstValue"]!, questionRange["secondValue"]! + 1)..shuffle();
    setState(() {
      currentIndex = 0;
      corrects = 0;
      wrongs = 0;
    });
  }

  void reset(BuildContext context) async {
    final result = await selectRangeDialog(context, allQuestions.length);
    if (result != null) {
      questionRange = result;
      resetQuestions();
    }
  }

  void updateQuestion({bool isCorrect = false}) async {
    setState(() {
      isAnswered = true;
      isCorrect ? corrects++ : wrongs++;
      result = ((corrects / (corrects + wrongs)) * 100).round();
    });
    await Future.delayed(duration, () {
      isAnswered = false;
      if (questions.length - 1 >= currentIndex + 1) {
        currentIndex++;
      } else {
        resetQuestions();
      }
    });
    setState(() {});
  }

  IconButton get resetButton {
    return IconButton(
      onPressed: () {
        setState(() {
          reset(context);
        });
      },
      icon: const Icon(
        Icons.settings,
      ),
    );
  }

  IconButton get messageMeButton {
    return IconButton(
      onPressed: () async {
        await WhatsappShare.share(
          text: 'Oh? Hi there',
          phone: '994773081398',
        );
      },
      icon: const Icon(Icons.question_answer_outlined),
    );
  }

  Align get question {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        questions[currentIndex].question,
        style: const TextStyle(
          fontSize: Constants.fontSizeLarge,
        ),
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
            isCorrectAnswer: item.isCorrectAnswer,
            isAnswered: isAnswered,
            updateQuestion: (value) => updateQuestion(isCorrect: value),
            duration: duration,
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
              '${correct ? corrects : wrongs}',
              style: const TextStyle(
                fontSize: Constants.fontSizeMedium,
              ),
            ),
          )
        ],
      ),
    );
  }

  Text get resultRate {
    return Text(
      '$result%',
      style: const TextStyle(
        fontSize: Constants.fontSizeMedium,
      ),
    );
  }

  Text get appBarTitle {
    return Text(
      widget.subject.title,
      style: const TextStyle(
        fontSize: Constants.fontSizeSmall,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  AppBar get appBar {
    return AppBar(
      title: appBarTitle,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      actions: [messageMeButton, resetButton],
    );
  }

  SizedBox get bottomAppBar {
    return SizedBox(
      height: appBar.preferredSize.height,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor,
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: answerCount(),
              ),
            ),
            Expanded(
              child: Center(
                child: resultRate,
              ),
            ),
            Expanded(
              child: Center(
                child: answerCount(correct: true),
              ),
            ),
            const Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton get finishButton {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {},
      child: const Text(
        '', // 'Bitir' ,
        style: TextStyle(
          fontSize: Constants.fontSizeSmall,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: finishButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: IgnorePointer(
        ignoring: isAnswered,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              question,
              answers,
              Container(
                padding: EdgeInsets.only(bottom: appBar.preferredSize.height - 10),
                alignment: Alignment.topCenter,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      '${currentIndex + 1} / ${questions.length}',
                      style: const TextStyle(
                        fontSize: Constants.fontSizeSmall,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: bottomAppBar,
    );
  }
}
