import 'package:examination/components/core/appbar.dart';
import 'package:examination/components/core/bordered_container.dart';
import 'package:examination/components/core/bottom_appbar.dart';
import 'package:examination/components/core/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../components/answer_button.dart';
import '../components/dialogs/select_index_dialog.dart';
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
      icon: const Icon(Icons.settings),
    );
  }

  //! Finish Button
  FloatingActionButton get finishButton {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: onFinishButtonPressed,
      child: Text(
        'Finish',
        style: TextStyle(
          fontSize: Constants.fontSizeSmall,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }

  //! Body
  //? Question
  BorderedContainer get question {
    return BorderedContainer(
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
      child: Listener(
        onPointerDown: (event) {
          events.add(event);
          setState(() {
            if (events.length > 1) {
              singleTap = false;
            }
          });
        },
        onPointerUp: (event) {
          events.clear();
          setState(() {
            singleTap = true;
          });
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: controller.getCurrentQuestion.answers.map((answer) {
            return AnswerButton(
              currentAnswer: answer,
              controller: controller,
              singleTap: singleTap,
              updateQuestion: (value) => updateQuestion(isCorrect: value),
            );
          }).toList(),
        ),
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
  BottomAppBarCore get bottomAppBar {
    return BottomAppBarCore(
      child: Row(
        children: [
          Expanded(child: Center(child: answerCount())),
          Expanded(child: Center(child: resultRate)),
          Expanded(child: Center(child: answerCount(correct: true))),
          const Spacer(flex: 1),
        ],
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
              '${correct ? controller.resultController.getCorrects : controller.resultController.getIncorrects}',
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
      '${controller.resultController.getCurrentResult}%',
      style: const TextStyle(
        fontSize: Constants.fontSizeMedium,
        color: Colors.white,
      ),
    );
  }

  //! Scaffold
  @override
  Widget build(BuildContext context) {
    return ScaffoldCore(
      appBar: AppBarCore(
        titleText: widget.subject.title,
        actions: [messageMeButton, settingsButton],
      ),
      floatingActionButton: finishButton,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ))
          : Padding(
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
