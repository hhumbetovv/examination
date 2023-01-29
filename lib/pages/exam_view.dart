import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../components/answer_button.dart';
import '../components/select_index_dialog.dart';
import '../constants.dart';
import '../model/subjects.dart';
import 'exam_modal.dart';

class ExamView extends StatefulWidget {
  const ExamView({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends ExamModal {
  //! AppBar
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

  //? Title
  Text get appBarTitle {
    return Text(
      widget.subject.title,
      style: const TextStyle(
        fontSize: Constants.fontSizeSmall,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  //? Message Me Button
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

  //? Settings Button
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

  //! Finish Button
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

  //! Body
  //? Question
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

  //? Answers
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

  //? Index Indicator
  Padding get indexIndicator {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 2, child: decreaseIndex),
          Expanded(flex: 3, child: changeIndex),
          Expanded(flex: 2, child: increaseIndex),
        ],
      ),
    );
  }

  //? Decrease Index Button
  Align get decreaseIndex {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => changeQuestion(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  //? Change Index Button
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

  //? Increase Index Button
  Align get increaseIndex {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => changeQuestion(increase: true),
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  //! Bottom AppBar
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
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  //? Answer Count
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

  //? Result Rate
  Text get resultRate {
    return Text(
      '${controller.result}%',
      style: const TextStyle(
        fontSize: Constants.fontSizeMedium,
        color: Colors.white,
      ),
    );
  }

  //! Scaffold
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
