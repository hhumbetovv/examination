import 'package:examination/cubits/index_cubit.dart';
import 'package:examination/cubits/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/subject.dart';
import '../../utils/constants.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/bordered_container.dart';
import '../../widgets/dialogs/select_index_dialog.dart';
import 'exam_modal.dart';

class ExamView extends StatefulWidget {
  const ExamView({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final SubjectModel subject;

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends ExamModal {
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

  //? Change Theme Button
  GestureDetector get changeThemeButton {
    return GestureDetector(
      onLongPress: () {
        context.read<ThemeModeCubit>().changeMode();
      },
      child: IconButton(
        onPressed: () {
          context.read<IndexCubit>().changeIndex();
        },
        icon: const Icon(
          Icons.color_lens_outlined,
        ),
      ),
    );
  }

  //! Finish Button
  FloatingActionButton get finishButton {
    return FloatingActionButton(
      onPressed: onFinishButtonPressed,
      child: const Text('Finish'),
    );
  }

  //! Body
  //? Question
  BorderedContainer get question {
    return BorderedContainer(
      alignment: ResponsiveBreakpoints.of(context).isDesktop ? Alignment.topLeft : Alignment.centerLeft,
      child: Text(
        controller.getCurrentQuestion.question,
        style: const TextStyle(
          fontSize: Constants.fontSizeLarge,
        ),
      ),
    );
  }

  //? Answers
  Listener get answers {
    return Listener(
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

  //! Bottom AppBar
  SizedBox get bottomAppBar {
    return SizedBox(
      height: Constants.appBarHeight,
      child: BottomAppBar(
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
              '${correct ? controller.resultController.getCorrects : controller.resultController.getIncorrects}',
              style: const TextStyle(
                fontSize: Constants.fontSizeMedium,
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
      ),
      textAlign: TextAlign.center,
    );
  }

  //! Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.title),
        actions: [changeThemeButton, settingsButton],
      ),
      floatingActionButton: finishButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
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
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) changeQuestion(increase: true);
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) changeQuestion();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Column(
                    children: [
                      Text(
                        controller.resultController.getDuration,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ResponsiveBreakpoints.of(context).isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: question),
                                  const SizedBox(width: 10),
                                  Expanded(child: answers),
                                ],
                              )
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    question,
                                    answers,
                                  ],
                                ),
                              ),
                      ),
                      indexIndicator,
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: bottomAppBar,
    );
  }
}
