import 'package:examination/global/index_cubit.dart';
import 'package:examination/global/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../model/subjects.dart';
import '../widgets/bordered_container.dart';
import 'exam_view.dart';
import 'learning_view.dart';

class SelectView extends StatefulWidget {
  const SelectView({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  final List<Subject> subjects;

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  //! Whatsapp Message Button
  IconButton get waMessageButton {
    return IconButton(
      onPressed: () async {
        await WhatsappShare.share(
          text: 'Oh? Hi there',
          phone: '994773081398',
        );
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
          waMessageButton,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
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
