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
import 'learning_model.dart';

class LearningView extends StatefulWidget {
  const LearningView({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final SubjectModel subject;

  @override
  State<LearningView> createState() => _LearningViewState();
}

class _LearningViewState extends LearningModel {
  //? Settings Button
  IconButton get settingsButton {
    return IconButton(
      onPressed: () {
        updateSettings(context);
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
  List<AnswerButton> get answers {
    return controller.getCurrentQuestion.answers.map((answer) {
      return AnswerButton(
        currentAnswer: answer,
        controller: controller,
        isLearning: true,
      );
    }).toList();
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
        actions: [changeThemeButton, settingsButton],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) changeQuestion(increase: true);
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) changeQuestion();
        },
        child: GestureDetector(
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
            child: ResponsiveBreakpoints.of(context).isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: question),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: answers,
                          ),
                        ),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        question,
                        ...answers,
                      ],
                    ),
                  ),
          ),
        ),
      ),
      bottomSheet: bottomAppBar,
    );
  }
}
