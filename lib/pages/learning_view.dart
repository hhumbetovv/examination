import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../model/subjects.dart';
import '../utils/constants.dart';
import '../widgets/answer_button.dart';
import '../widgets/bordered_container.dart';
import '../widgets/dialogs/select_index_dialog.dart';
import 'learning_modal.dart';

class LearningView extends StatefulWidget {
  const LearningView({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

  @override
  State<LearningView> createState() => _LearningViewState();
}

class _LearningViewState extends LearningModal {
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
        updateSettings(context);
      },
      icon: const Icon(Icons.settings),
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
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: controller.getCurrentQuestion.answers.map((answer) {
          return AnswerButton(
            currentAnswer: answer,
            controller: controller,
            isLearning: true,
          );
        }).toList(),
      ),
    );
  }

  //! Bottom AppBar
  SizedBox get bottomAppBar {
    return SizedBox(
      height: Constants.appBarHeight,
      child: BottomAppBar(
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(child: decreaseIndex),
            Expanded(child: changeIndex),
            Expanded(child: increaseIndex),
          ],
        ),
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
          child: Text('${controller.currentIndex + 1} / ${controller.currentSettings.count}'),
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

  //! Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.title),
        actions: [messageMeButton, settingsButton],
      ),
      body: GestureDetector(
        onTap: () {
          swipeDirection = 'zero';
        },
        onPanUpdate: (details) {
          if (details.delta.dx < 0) swipeDirection = 'left';
          if (details.delta.dx > 0) swipeDirection = 'right';
        },
        onPanEnd: (details) {
          if (swipeDirection == 'zero') return;
          if (swipeDirection == 'left') changeQuestion(increase: true);
          if (swipeDirection == 'right') changeQuestion();
        },
        child: Padding(
          padding: const EdgeInsets.all(15) + const EdgeInsets.only(bottom: Constants.appBarHeight - 10),
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
