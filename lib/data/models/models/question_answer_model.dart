import 'package:bilbank_app/core/enums/answer_error_code.dart';

class QuestionAnswerModel {
  final bool? ok;
  final AnswerErrorCode? code;
  final String? error;
  final bool? isCorrect;

  QuestionAnswerModel({
    this.ok,
    this.code,
    this.error,
    this.isCorrect,
  });

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      ok: json['ok'],
      code: AnswerErrorCodeX.fromString(json['code']),
      error: json['error'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'code': code?.codeString,
      'error': error,
      'isCorrect': isCorrect,
    };
  }
}
