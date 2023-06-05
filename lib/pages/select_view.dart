import 'dart:html' as html;

import 'package:examination/cubits/index_cubit.dart';
import 'package:examination/cubits/theme_mode_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/subject.dart';
import '../widgets/bordered_container.dart';
import 'exam/exam_view.dart';
import 'learning/learning_view.dart';

class SelectView extends StatefulWidget {
  const SelectView({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  final List<SubjectModel> subjects;

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  //! Whatsapp Message Button
  IconButton get waMessageButton {
    return IconButton(
      onPressed: () async {
        //! Change this for platforms
        // await WhatsappShare.share(
        //   text: 'Oh? Hi there',
        //   phone: '994503281398',
        // );
        html.window.open('https://wa.me/+994503281398', "_blank");
      },
      icon: const Icon(Icons.question_answer_outlined),
    );
  }

  //! Change Theme Button
  GestureDetector get changeThemeButton {
    return GestureDetector(
      onLongPress: () {
        context.read<ThemeModeCubit>().changeMode();
      },
      child: IconButton(
        onPressed: () {
          context.read<IndexCubit>().changeIndex();
        },
        icon: const Icon(
          Icons.color_lens_outlined,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examination'),
        actions: [
          changeThemeButton,
          if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) waMessageButton,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            constraints: const BoxConstraints(
              maxWidth: 768,
            ),
            child: Wrap(
              runSpacing: 10,
              children: widget.subjects.length == 1
                  ? [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamView(subject: widget.subjects[0]),
                          ),
                        ),
                        child: const Text('Exam'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearningView(subject: widget.subjects[0]),
                          ),
                        ),
                        child: const Text('Learning'),
                      ),
                    ]
                  : widget.subjects.map((subject) {
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
