import 'package:examination/exam.dart';
import 'package:flutter/material.dart';

class SelectSubject extends StatelessWidget {
  const SelectSubject({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> subjects = [
      {'title': 'Bioinformatika', 'id': 'bioinformatics'},
      {'title': 'Şəbəkə Təhlükəsizliyi', 'id': 'networkSecurity'},
      {'title': 'Fəlsəfə', 'id': 'philosophy'}
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examination'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              runSpacing: 10,
              children: subjects.map((subject) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Exam(
                          title: subject['title'] ?? '',
                          subject: subject['id'] ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: Text(
                    subject['title'] ?? '',
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
