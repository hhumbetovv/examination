class Question {
  final String question;
  final List<Answer> answers;
  bool isAnswered = false;

  Question({required this.question, required this.answers});

  void setIsAnswered() {
    isAnswered = true;
  }

  //! All Questions
  static List<Question> getAllQuestions(String bank) {
    return createQuestionsList(bank)
        .map(
          (item) => Question(
            question: item[0],
            answers: [
              Answer(answer: item[1], isCorrectAnswer: true),
              Answer(answer: item[2]),
              Answer(answer: item[3]),
              Answer(answer: item[4]),
              Answer(answer: item[5]),
            ]..shuffle(),
          ),
        )
        .toList();
  }

  //! Questions with Long Correct Answers
  static List<Question> getLongAnswerQuestions(String bank) {
    List<Question> longAnswerQuestionList = [];
    createQuestionsList(bank).forEach((item) {
      String correctAnswer = item[1];
      bool checker(String element) => correctAnswer.length > element.length;
      if (checker(item[2]) && checker(item[3]) && checker(item[4]) && checker(item[5])) {
        longAnswerQuestionList.add(
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
    return longAnswerQuestionList;
  }

  //! Questions with Short Correct Answers
  static List<Question> getShortAnswerQuestions(String bank) {
    List<Question> shortAnswerQuestionList = [];
    createQuestionsList(bank).forEach((item) {
      String correctAnswer = item[1];
      bool checker(String element) => correctAnswer.length > element.length;
      if (!(checker(item[2]) && checker(item[3]) && checker(item[4]) && checker(item[5]))) {
        shortAnswerQuestionList.add(
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
    return shortAnswerQuestionList;
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
List<List<String>> createQuestionsList(String bank) {
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
