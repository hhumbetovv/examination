import 'question.dart';

class ResultController {
  int blanks = 0;
  List<Question> corrects = [];
  List<Question> incorrects = [];

  ResultController({required int count, List<Question>? corrects, List<Question>? incorrects}) {
    blanks = count;
    this.corrects = corrects ?? [];
    this.incorrects = incorrects ?? [];
  }

  @override
  String toString() {
    return 'blanks: $blanks, corrects: $corrects, incorrects: $incorrects';
  }

  ResultController get finalResults {
    return ResultController(count: blanks, corrects: corrects, incorrects: incorrects);
  }

  void updateResult({required Question question, required bool isCorrect}) {
    if (isCorrect) {
      corrects.add(question);
    } else {
      incorrects.add(question);
    }
    blanks--;
    corrects.sort((a, b) => a.compareTo(b));
    incorrects.sort((a, b) => a.compareTo(b));
  }

  void resetResult({required int count}) {
    blanks = count;
    corrects = [];
    incorrects = [];
  }

  int get getCurrentResult {
    int answered = corrects.length + incorrects.length;
    return answered != 0 ? ((corrects.length / (corrects.length + incorrects.length)) * 100).round() : 0;
  }

  int get getResult {
    return ((corrects.length / (corrects.length + incorrects.length + blanks)) * 100).round();
  }

  int get getCorrects {
    return corrects.length;
  }

  int get getIncorrects {
    return incorrects.length;
  }
}
