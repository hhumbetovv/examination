import 'package:examination/model/settings.dart';

class Question {
  final String question;
  final List<Answer> answers;
  bool isAnswered = false;

  Question({required this.question, required this.answers});

  int compareTo(other) {
    return int.parse(question.substring(0, question.indexOf('.'))).compareTo(
      int.parse(other.question.substring(0, other.question.indexOf('.'))),
    );
  }

  void setIsAnswered() {
    isAnswered = true;
  }

  static List<Question> getQuestions(String bank, QuestionTypes type) {
    List<Question> list = [];
    _createQuestionsList(bank).forEach((item) {
      bool checker() {
        switch (type) {
          case QuestionTypes.longs:
            return item[1].length > item[2].length &&
                item[1].length > item[3].length &&
                item[1].length > item[4].length &&
                item[1].length > item[5].length;
          case QuestionTypes.shorts:
            return !(item[1].length > item[2].length &&
                item[1].length > item[3].length &&
                item[1].length > item[4].length &&
                item[1].length > item[5].length);
          default:
            return true;
        }
      }

      if (checker()) {
        list.add(
          Question(
            question: item[0],
            answers: [
              Answer(answer: item[1], isCorrectAnswer: true),
              Answer(answer: item[2]),
              Answer(answer: item[3]),
              Answer(answer: item[4]),
              Answer(answer: item[5]),
            ]..shuffle(),
          ),
        );
      }
    });
    return list;
  }
}

class Answer {
  final String answer;
  final bool isCorrectAnswer;
  bool isAnswered = false;

  Answer({required this.answer, this.isCorrectAnswer = false});

  void setIsAnswered() {
    isAnswered = true;
  }
}

//! Create Questions List from Bank
List<List<String>> _createQuestionsList(String bank) {
  List<String> questionList = bank.split('spacer');
  List<String> dublicatedList = [];
  List<List<String>> finalList = [];
  int questionLimit = 0;
  questionList.asMap().forEach((key, value) {
    dublicatedList.add(value);
    if ((key + 1) % 6 == 0) {
      dublicatedList.add('questionSpacer');
      questionLimit++;
    } else {
      dublicatedList.add('lineSpacer');
    }
  });
  dublicatedList.join('').split('questionSpacer').asMap().forEach((key, value) {
    if (key < questionLimit) {
      List<String> listItem = value.split('lineSpacer');
      int correctAnswerIndex = listItem.indexWhere((element) => element.contains('√ '));
      List<String> dublicatedListItem = [
        listItem[0],
        listItem[correctAnswerIndex].substring(2),
      ];
      listItem.asMap().forEach(
        (key, value) {
          if (key != 0 && key != correctAnswerIndex) {
            dublicatedListItem.add(value);
          }
        },
      );
      finalList.add(dublicatedListItem);
    }
  });
  return finalList;
}
