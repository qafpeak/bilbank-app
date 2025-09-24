class QuestionModel {
  String? id;
  String? question;
  int? multiplier;

  QuestionModel({this.id, this.question, this.multiplier});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    multiplier = json['multiplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['multiplier'] = this.multiplier;
    return data;
  }
}
