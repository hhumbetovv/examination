import 'package:examination/components/answer_button.dart';
import 'package:examination/components/select_index_dialog.dart';
import 'package:examination/components/settings_dialog.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/question_controller.dart';
import 'package:examination/model/subjects.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class Learning extends StatefulWidget {
  const Learning({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  late final QuestionController controller;
  String? swipeDirection;

  @override
  void initState() {
    super.initState();
    controller = QuestionController(blank: widget.subject.blank);
    controller.initialize(isLearning: true);
  }

  @override
  void dispose() {
    super.dispose();
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

  void updateSettings(BuildContext context) async {
    final result = await settingsDialog(context, controller);
    if (result ?? false) {
      setState(() {
        controller.resetValues();
      });
    }
  }

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
        updateSettings(context);
      },
      icon: const Icon(
        Icons.settings,
      ),
    );
  }

  //! Body
  //? Questions
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
            isLearning: true,
          );
        }).toList(),
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
            Expanded(child: decreaseIndex),
            Expanded(child: changeIndex),
            Expanded(child: increaseIndex),
          ],
        ),
      ),
    );
  }

  //? Decrease Index Button
  Center get decreaseIndex {
    return Center(
      child: IconButton(
        onPressed: () => changeQuestion(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
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
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  //? Increase Index Button
  Center get increaseIndex {
    return Center(
      child: IconButton(
        onPressed: () => changeQuestion(increase: true),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  //! Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onPanUpdate: (details) {
          swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
        },
        onPanEnd: (details) {
          if (swipeDirection == null) return;
          if (swipeDirection == 'left') changeQuestion(increase: true);
          if (swipeDirection == 'right') changeQuestion();
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
