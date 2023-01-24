import 'package:examination/components/bordered_container.dart';
import 'package:examination/components/custom_elevated_button.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/subjects.dart';
import 'package:examination/pages/exam.dart';
import 'package:examination/pages/learning.dart';
import 'package:flutter/material.dart';

class SelectMode extends StatelessWidget {
  const SelectMode({
    Key? key,
    required this.subject,
  }) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Examination',
          style: TextStyle(
            fontSize: Constants.fontSizeSmall,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BorderedContainer(
        child: Wrap(
          runSpacing: 10,
          children: [
            CustomElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Exam(subject: subject),
                ),
              ),
              text: 'Exam',
            ),
            CustomElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Learning(subject: subject),
                ),
              ),
              text: 'Learning',
            ),
          ],
        ),
      ),
    );
  }
}
