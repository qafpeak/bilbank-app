enum AnswerErrorCode {
  duplicateAnswer,
  invalidParams,
  authError,
  questionNotFound,
  unknown,
}

extension AnswerErrorCodeX on AnswerErrorCode {
  String get codeString {
    switch (this) {
      case AnswerErrorCode.duplicateAnswer:
        return 'DUPLICATE_ANSWER';
      case AnswerErrorCode.invalidParams:
        return 'INVALID_PARAMS';
      case AnswerErrorCode.authError:
        return 'AUTH_ERROR';
      case AnswerErrorCode.questionNotFound:
        return 'QUESTION_NOT_FOUND';
      case AnswerErrorCode.unknown:
      default:
        return 'UNKNOWN';
    }
  }

  static AnswerErrorCode fromString(String? code) {
    switch (code) {
      case 'DUPLICATE_ANSWER':
        return AnswerErrorCode.duplicateAnswer;
      case 'INVALID_PARAMS':
        return AnswerErrorCode.invalidParams;
      case 'AUTH_ERROR':
        return AnswerErrorCode.authError;
      case 'QUESTION_NOT_FOUND':
        return AnswerErrorCode.questionNotFound;
      default:
        return AnswerErrorCode.unknown;
    }
  }
}
