import 'package:examination/constants.dart';
import 'package:examination/model/subjects.dart';
import 'package:examination/pages/select_mode.dart';
import 'package:examination/pages/select_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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
        primaryColor: Constants.primaryColor,
        brightness: MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness,
      ),
      debugShowCheckedModeBanner: false,
      home: subjects.length == 1 ? SelectMode(subject: subjects[0]) : SelectSubject(subjects: subjects),
    );
  }
}
