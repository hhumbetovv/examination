import 'question.dart';
import 'settings.dart';

class QuestionController {
  //! Question bank
  final String bank;
  //! Type Lists
  List<String> typeList = ['All Questions', 'With Long Answer', 'With Short Answer'];
  //! Question Lists
  late final List<Question> allQuestions;
  late final List<Question> longAnswerQuestions;
  late final List<Question> shortAnswerQuestions;
  late List<Question> questions;
  late List<Question> randomQuestions;
  List<Question> incorrectQuestions = [];
  //! Settings
  late Settings currentSettings;
  late final Settings allQuestionSettings;
  late final Settings longAnswerQuestionSettings;
  late final Settings shortAnswerQuestionSettings;
  //! Current Questions
  late Question currentQuestion;
  //! Page Values
  int currentIndex = 0;
  int corrects = 0;
  int wrongs = 0;
  int result = 0;

  QuestionController({required this.bank});

  void initialize({bool isLearning = false}) {
    allQuestions = Question.getAllQuestions(bank);
    allQuestionSettings = Settings(
      firstIndex: 0,
      lastIndex: allQuestions.length - 1,
      count: isLearning ? allQuestions.length : 50,
      random: !isLearning,
      type: QuestionTypes.all,
    );
    longAnswerQuestions = Question.getLongAnswerQuestions(bank);
    longAnswerQuestionSettings = Settings(
      firstIndex: 0,
      lastIndex: longAnswerQuestions.length - 1,
      count: isLearning ? longAnswerQuestions.length : 50,
      random: !isLearning,
      type: QuestionTypes.longs,
    );
    shortAnswerQuestions = Question.getShortAnswerQuestions(bank);
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
    incorrectQuestions.clear();
  }

  //! Index Functions
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

  void setIncorrectQuestion() {
    incorrectQuestions.add(getCurrentQuestion);
  }
}
