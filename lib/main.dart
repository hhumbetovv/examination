import 'package:flutter/material.dart';

import 'model/subjects.dart';
import 'pages/select_mode.dart';
import 'pages/select_subject.dart';
import 'theme.dart';

void main() {
  runApp(const Examination());
}

class Examination extends StatefulWidget {
  const Examination({super.key});

  @override
  State<Examination> createState() => _ExaminationState();
}

class _ExaminationState extends State<Examination> {
  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = Subject.subjects;
    final AppTheme appTheme = AppTheme();

    return MaterialApp(
      title: 'Examination',
      theme: appTheme.light(AppColors.colors[0]),
      darkTheme: appTheme.dark(AppColors.colors[0]),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: subjects.length == 1 ? SelectMode(subject: subjects[0]) : SelectSubject(subjects: subjects),
    );
  }
}
