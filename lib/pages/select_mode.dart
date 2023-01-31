import 'package:flutter/material.dart';

import '../model/subjects.dart';
import '../widgets/bordered_container.dart';
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
      appBar: AppBar(title: Text(subject.title)),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            child: Wrap(
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamView(subject: subject),
                    ),
                  ),
                  child: const Text('Exam'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearningView(subject: subject),
                    ),
                  ),
                  child: const Text('Learning'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
