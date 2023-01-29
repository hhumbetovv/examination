import 'package:examination/components/bordered_container.dart';
import 'package:examination/components/custom_elevated_button.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/subjects.dart';
import 'package:examination/pages/select_mode.dart';
import 'package:flutter/material.dart';

class SelectSubject extends StatelessWidget {
  const SelectSubject({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  final List<Subject> subjects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Examination',
          style: TextStyle(
            fontSize: Constants.fontSizeSmall,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            child: Wrap(
              runSpacing: 10,
              children: subjects.map((subject) {
                return CustomElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectMode(
                        subject: subject,
                      ),
                    ),
                  ),
                  text: subject.title,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
