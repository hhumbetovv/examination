import 'package:examination/components/answer_button.dart';
import 'package:examination/components/select_index_dialog.dart';
import 'package:examination/components/select_setting_dialog.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/question.dart';
import 'package:examination/model/subjects.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class Learning extends StatefulWidget {
  const Learning({
    Key? key,
    required this.subject,
    this.isOnlySubject = false,
  }) : super(key: key);

  final Subject subject;
  final bool isOnlySubject;

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  List<Question> allQuestions = [];
  int currentIndex = 0;
  String? swipeDirection;

  @override
  void initState() {
    super.initState();
    allQuestions = Question.shortAnswerQuestions(widget.subject.blank);
  }

  void updateQuestion({bool increase = false}) {
    setState(() {
      if (increase && currentIndex != allQuestions.length - 1) {
        currentIndex++;
      } else if (!increase && currentIndex != 0) {
        currentIndex--;
      }
    });
  }

  void onSettingsButtonTap() async {
    var result = await selectSettingDialog(context);
    if (result != null && result != 'cancel') {
      currentIndex = 0;
      if (result == 'all') {
        allQuestions = Question.questions(widget.subject.blank);
      } else if (result == 'longs') {
        allQuestions = Question.longAnswerQuestions(widget.subject.blank);
      } else if (result == 'shorts') {
        allQuestions = Question.shortAnswerQuestions(widget.subject.blank);
      }
      setState(() {});
    }
  }

  IconButton get settingsButton {
    return IconButton(
      onPressed: onSettingsButtonTap,
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
        allQuestions[currentIndex].question,
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
        children: allQuestions[currentIndex].answers.map((item) {
          return AnswerButton(
            answer: item.answer,
            isCorrectAnswer: item.isCorrectAnswer,
            isLearning: true,
          );
        }).toList(),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: [messageMeButton, settingsButton],
    );
  }

  IconButton get increaseIndex {
    return IconButton(
      onPressed: () => updateQuestion(increase: true),
      icon: const Icon(Icons.arrow_forward_ios),
    );
  }

  IconButton get decreaseIndex {
    return IconButton(
      onPressed: () => updateQuestion(),
      icon: const Icon(Icons.arrow_back_ios),
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
                child: decreaseIndex,
              ),
            ),
            Expanded(child: indexIndicator),
            Expanded(
              child: Center(
                child: increaseIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onIndexIndicatorTap() async {
    final result = await selectIndexDialog(context, currentIndex, allQuestions.length);
    if (result != null) {
      setState(() {
        currentIndex = result;
      });
    }
  }

  Align get indexIndicator {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onIndexIndicatorTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            '${currentIndex + 1} / ${allQuestions.length}',
            style: const TextStyle(
              fontSize: Constants.fontSizeSmall,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onPanUpdate: (details) {
          swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
        },
        onPanEnd: (details) {
          if (swipeDirection == null) {
            return;
          }
          if (swipeDirection == 'left') {
            updateQuestion(increase: true);
          }
          if (swipeDirection == 'right') {
            updateQuestion();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15) + EdgeInsets.only(bottom: appBar.preferredSize.height - 10),
          child: Column(
            children: [
              question,
              answers,
            ],
          ),
        ),
      ),
      bottomSheet: bottomAppBar,
    );
  }
}
