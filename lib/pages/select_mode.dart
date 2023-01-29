import 'package:flutter/material.dart';

import '../components/bordered_container.dart';
import '../components/custom_elevated_button.dart';
import '../constants.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject.title,
          style: const TextStyle(
            fontSize: Constants.fontSizeSmall,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
