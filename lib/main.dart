import 'package:examination/select_subject.dart';
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
    return MaterialApp(
      title: 'Examination',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const SelectSubject(),
    );
  }
}
