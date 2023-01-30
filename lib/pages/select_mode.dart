import 'package:examination/components/core/appbar.dart';
import 'package:examination/components/core/scaffold.dart';
import 'package:flutter/material.dart';

import '../components/core/bordered_container.dart';
import '../components/customs/custom_elevated_button.dart';
import '../model/subjects.dart';
import 'exam_view.dart';
import 'learning_view.dart';

class SelectMode extends StatelessWidget {
  const SelectMode({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return ScaffoldCore(
      appBar: AppBarCore(titleText: subject.title),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            child: Wrap(
              runSpacing: 10,
              children: [
                CustomElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamView(subject: subject),
                    ),
                  ),
                  text: 'Exam',
                ),
                CustomElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningView(subject: subject),
                    ),
                  ),
                  text: 'Learning',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
