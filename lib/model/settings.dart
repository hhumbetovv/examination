enum QuestionTypes { all, longs, shorts }

class Settings {
  int firstIndex;
  late int defaultFirstIndex;
  int lastIndex;
  late int defaultLastIndex;
  int count;
  late int defaultCount;
  bool random;
  QuestionTypes type;

  Settings({
    required this.firstIndex,
    required this.lastIndex,
    required this.count,
    required this.random,
    required this.type,
  }) {
    defaultFirstIndex = firstIndex;
    defaultLastIndex = lastIndex;
    defaultCount = count;
  }

  void setQuestionType(QuestionTypes value) {
    type = value;
  }

  void setRandom(bool value) {
    random = value;
  }

  bool checkIndexes(int firstIndex, int lastIndex) {
    if (firstIndex >= lastIndex) return true;
    return false;
  }

  void setIndexSettings(int? firstIndex, int? lastIndex, int? count) {
    this.firstIndex = firstIndex != -1 ? firstIndex ?? this.firstIndex : 0;
    this.lastIndex = lastIndex != null && lastIndex > defaultLastIndex ? defaultLastIndex : lastIndex ?? this.lastIndex;
    if (count != null) {
      this.count = count > this.lastIndex - this.firstIndex + 1 ? this.lastIndex - this.firstIndex + 1 : count;
    } else {
      this.count =
          this.count > this.lastIndex - this.firstIndex + 1 ? this.lastIndex - this.firstIndex + 1 : this.count;
    }
  }
}
