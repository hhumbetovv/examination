import 'package:examination/constants.dart';
import 'package:flutter/material.dart';

import 'model/subjects.dart';
import 'pages/select_mode.dart';
import 'pages/select_subject.dart';

void main() {
  runApp(const Examination());
}

class Examination extends StatelessWidget {
  const Examination({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = Subject.subjects;

    return MaterialApp(
      title: 'Examination',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Constants.primaryColorDark,
          secondary: Constants.secondaryColorDark,
          background: Constants.background,
          onPrimary: Colors.black,
          tertiary: Colors.white,
        ),
        brightness: MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness,
      ),
      debugShowCheckedModeBanner: false,
      home: subjects.length == 1 ? SelectMode(subject: subjects[0]) : SelectSubject(subjects: subjects),
    );
  }
}
