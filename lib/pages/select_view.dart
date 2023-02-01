import 'package:flutter/material.dart';

import '../model/subjects.dart';
import '../widgets/bordered_container.dart';
import 'exam_view.dart';
import 'learning_view.dart';

class SelectView extends StatelessWidget {
  const SelectView({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  final List<Subject> subjects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Examination')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            child: Wrap(
              runSpacing: 10,
              children: subjects.length == 1
                  ? [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamView(subject: subjects[0]),
                          ),
                        ),
                        child: const Text('Exam'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearningView(subject: subjects[0]),
                          ),
                        ),
                        child: const Text('Learning'),
                      ),
                    ]
                  : subjects.map((subject) {
                      return ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectView(
                              subjects: [subject],
                            ),
                          ),
                        ),
                        child: Text(subject.title),
                      );
                    }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
