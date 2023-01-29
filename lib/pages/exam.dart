import 'package:examination/components/answer_button.dart';
import 'package:examination/components/select_index_dialog.dart';
import 'package:examination/components/settings_dialog.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/question_controller.dart';
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
  late final QuestionController controller;

  @override
  void initState() {
    super.initState();
    controller = QuestionController(blank: widget.subject.blank);
    controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetQuestions() {
    setState(() {
      controller.resetValues();
    });
  }

  void updateSettings(BuildContext context) async {
    final result = await settingsDialog(context, controller);
    if (result ?? false) {
      resetQuestions();
    }
  }

  void updateQuestion({bool isCorrect = false}) async {
    setState(() {
      controller.getCurrentQuestion.setIsAnswered();
      controller.updateResults(isCorrect);
    });
  }

  void changeQuestion({bool increase = false}) {
    setState(() {
      if (increase) {
        controller.increaseIndex();
      } else {
        controller.decreaseIndex();
      }
    });
  }

  IconButton get settingsButton {
    return IconButton(
      onPressed: () {
        setState(() {
          updateSettings(context);
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
        controller.getCurrentQuestion.question,
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
        children: controller.getCurrentQuestion.answers.map((answer) {
          return AnswerButton(
            currentAnswer: answer,
            controller: controller,
            updateQuestion: (value) => updateQuestion(isCorrect: value),
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
              '${correct ? controller.corrects : controller.wrongs}',
              style: const TextStyle(
                fontSize: Constants.fontSizeMedium,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Text get resultRate {
    return Text(
      '${controller.result}%',
      style: const TextStyle(
        fontSize: Constants.fontSizeMedium,
        color: Colors.white,
      ),
    );
  }

  Text get appBarTitle {
    return Text(
      widget.subject.title,
      style: const TextStyle(
        fontSize: Constants.fontSizeSmall,
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

  SizedBox get bottomAppBar {
    return SizedBox(
      height: appBar.preferredSize.height,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor,
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(child: Center(child: answerCount())),
            Expanded(child: Center(child: resultRate)),
            Expanded(child: Center(child: answerCount(correct: true))),
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
        ),
      ),
    );
  }

  Align get increaseIndex {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => changeQuestion(increase: true),
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Center get changeIndex {
    return Center(
      child: InkWell(
        onTap: () async {
          final result = await selectIndexDialog(context, controller);
          if (result ?? false) setState(() {});
        },
        borderRadius: Constants.radiusMedium,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            '${controller.currentIndex + 1} / ${controller.currentSettings.count}',
            style: const TextStyle(
              fontSize: Constants.fontSizeSmall,
            ),
          ),
        ),
      ),
    );
  }

  Align get decraseIndex {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => changeQuestion(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Padding get indexIndicator {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 2, child: decraseIndex),
          Expanded(flex: 3, child: changeIndex),
          Expanded(flex: 2, child: increaseIndex),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: finishButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          children: [
            question,
            answers,
            indexIndicator,
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar,
    );
  }
}
