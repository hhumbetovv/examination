import 'package:flutter/material.dart';

import '../model/subjects.dart';
import '../widgets/bordered_container.dart';
import 'select_mode.dart';

class SelectSubject extends StatelessWidget {
  const SelectSubject({
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
              children: subjects.map((subject) {
                return ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectMode(
                        subject: subject,
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
