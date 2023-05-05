class SubjectModel {
  final String title;
  final String tag;
  final String bank;

  SubjectModel(this.title, this.tag, this.bank);

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      json['title'] as String,
      json['tag'] as String,
      json['bank'] as String,
    );
  }

  //! Subjects and Their Banks
  static List<SubjectModel> subjects = [];
}
