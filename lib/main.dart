import 'package:flutter/material.dart';

import 'model/subjects.dart';
import 'pages/select_view.dart';
import 'utils/theme.dart';

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
      theme: appTheme.light(AppColors.colors[3]),
      darkTheme: appTheme.dark(AppColors.colors[3]),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: SelectView(subjects: subjects),
    );
  }
}
