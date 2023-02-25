import 'question.dart';

class ResultController {
  int blanks = 0;
  List<Question> corrects = [];
  List<Question> incorrects = [];
  Duration duration = const Duration(seconds: 0);

  ResultController({
    required int count,
    List<Question>? corrects,
    List<Question>? incorrects,
    Duration? duration,
  }) {
    blanks = count;
    this.corrects = corrects ?? [];
    this.incorrects = incorrects ?? [];
    this.duration = duration ?? const Duration(seconds: 0);
  }

  ResultController get finalResults {
    return ResultController(
      count: blanks,
      corrects: corrects,
      incorrects: incorrects,
      duration: duration,
    );
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
    duration = const Duration(seconds: 0);
  }

  void setDuration(Duration value) {
    duration = value;
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

  String get getDuration {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(duration.inHours.remainder(24));
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
