import 'package:examination/model/question.dart';
import 'package:examination/model/settings.dart';

class QuestionController {
  //! blank
  final String blank;
  //! Type Lists
  List<String> typeList = ['All Questions', 'With Long Answer', 'With Short Answer'];
  //! Question Lists
  late final List<Question> allQuestions;
  late final List<Question> longAnswerQuestions;
  late final List<Question> shortAnswerQuestions;
  late List<Question> questions;
  late List<Question> randomQuestions;
  List<Question> incorrectAnsweredQuestions = [];
  //! Settings
  late Settings currentSettings;
  late final Settings allQuestionSettings;
  late final Settings longAnswerQuestionSettings;
  late final Settings shortAnswerQuestionSettings;
  //! Current Questions
  late Question currentQuestion;
  //! List Parameters
  int currentIndex = 0;
  int corrects = 0;
  int wrongs = 0;
  int result = 0;

  QuestionController({required this.blank});

  void initialize({bool isLearning = false}) {
    allQuestions = Question.getAllQuestions(blank);
    allQuestionSettings = Settings(
      firstIndex: 0,
      lastIndex: allQuestions.length - 1,
      count: isLearning ? allQuestions.length : 50,
      random: !isLearning,
      type: QuestionTypes.all,
    );
    longAnswerQuestions = Question.getLongAnswerQuestions(blank);
    longAnswerQuestionSettings = Settings(
      firstIndex: 0,
      lastIndex: longAnswerQuestions.length - 1,
      count: isLearning ? longAnswerQuestions.length : 50,
      random: !isLearning,
      type: QuestionTypes.longs,
    );
    shortAnswerQuestions = Question.getShortAnswerQuestions(blank);
    shortAnswerQuestionSettings = Settings(
      firstIndex: 0,
      lastIndex: shortAnswerQuestions.length - 1,
      count: isLearning ? shortAnswerQuestions.length : 50,
      random: !isLearning,
      type: QuestionTypes.shorts,
    );
    changeSettings(QuestionTypes.all);
    changeQuestions(QuestionTypes.all);
    currentQuestion = questions[currentIndex];
  }

  void changeQuestions(QuestionTypes type) {
    if (type == QuestionTypes.all) {
      questions = allQuestions.sublist(currentSettings.firstIndex, currentSettings.lastIndex + 1);
    } else if (type == QuestionTypes.longs) {
      questions = longAnswerQuestions.sublist(currentSettings.firstIndex, currentSettings.lastIndex + 1);
    } else if (type == QuestionTypes.shorts) {
      questions = shortAnswerQuestions.sublist(currentSettings.firstIndex, currentSettings.lastIndex + 1);
    }
    randomQuestions = [...questions]..shuffle();
  }

  void changeSettings(QuestionTypes type) {
    if (type == QuestionTypes.all) {
      currentSettings = allQuestionSettings;
    } else if (type == QuestionTypes.longs) {
      currentSettings = longAnswerQuestionSettings;
    } else if (type == QuestionTypes.shorts) {
      currentSettings = shortAnswerQuestionSettings;
    }
  }

  Question get getCurrentQuestion {
    return currentSettings.random ? randomQuestions[currentIndex] : questions[currentIndex];
  }

  void resetValues() {
    currentIndex = 0;
    corrects = 0;
    wrongs = 0;
    result = 0;
    changeQuestions(currentSettings.type);
  }

  void increaseIndex() {
    if (currentIndex < currentSettings.count - 1) {
      currentIndex++;
    } else {
      currentIndex = 0;
    }
  }

  void setIndex(int index) {
    currentIndex = index;
    if (index == -1) currentIndex = 0;
    if (index > currentSettings.count - 1) currentIndex = currentSettings.count - 1;
  }

  void decreaseIndex() {
    if (currentIndex > 0) {
      currentIndex--;
    } else {
      currentIndex = currentSettings.count - 1;
    }
  }

  void updateResults(bool isCorrect) {
    isCorrect ? corrects++ : wrongs++;
    result = ((corrects / (corrects + wrongs)) * 100).round();
  }

  void setIncorrectAnsweredQuestion() {
    incorrectAnsweredQuestions.add(getCurrentQuestion);
  }
}
