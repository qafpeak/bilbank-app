/// Quiz oyunun durumları
enum QuizState {
  waiting,     // Bekliyor (countdown)
  playing,     // Oyun oynanıyor
  finished,    // Oyun bitti
}

/// Quiz veri modeli
class QuizData {
  final QuizState state;
  final String? roomId;
  final int countdown;
  final QuestionData? currentQuestion;
  final AnswerResult? lastAnswerResult;
  final int score;
  final int questionTimeLeft;
  final int rank;
  final RankingData? rankingData;
  final int trivaBalance;

  const QuizData({
    this.state = QuizState.waiting,
    this.roomId,
    this.countdown = 0,
    this.currentQuestion,
    this.lastAnswerResult,
    this.score = 0,
    this.questionTimeLeft = 0,
    this.rank = 0,
    this.rankingData,
    this.trivaBalance = 0,
  });

  QuizData copyWith({
    QuizState? state,
    String? roomId,
    int? countdown,
    QuestionData? currentQuestion,
    AnswerResult? lastAnswerResult,
    int? score,
    int? questionTimeLeft,
    int? rank,
    RankingData? rankingData,
    int? trivaBalance,
    bool clearRankingData = false,
  }) {
    return QuizData(
      state: state ?? this.state,
      roomId: roomId ?? this.roomId,
      countdown: countdown ?? this.countdown,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      lastAnswerResult: lastAnswerResult ?? this.lastAnswerResult,
      score: score ?? this.score,
      questionTimeLeft: questionTimeLeft ?? this.questionTimeLeft,
      rank: rank ?? this.rank,
      rankingData: clearRankingData ? null : (rankingData ?? this.rankingData),
      trivaBalance: trivaBalance ?? this.trivaBalance,
    );
  }

  bool get hasQuestion => currentQuestion != null;
  bool get isWaiting => state == QuizState.waiting;
  bool get isPlaying => state == QuizState.playing;
  bool get isFinished => state == QuizState.finished;
}

/// Soru veri modeli
class QuestionData {
  final String id;
  final String question;
  final String correctAnswer;
  final int multiplier;
  final int? timeLeft;

  const QuestionData({
    required this.id,
    required this.question,
    required this.correctAnswer,
    this.multiplier = 1,
    this.timeLeft,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] ?? json['_id'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      multiplier: json['multiplier'] ?? 1,
      timeLeft: json['timeLeft'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'correctAnswer': correctAnswer,
      'multiplier': multiplier,
      'timeLeft': timeLeft,
    };
  }
}

/// Cevap sonucu
class AnswerResult {
  final bool isCorrect;
  final String correctAnswer;
  final int scoreGained;
  final int totalScore;
  final String? message;

  const AnswerResult({
    required this.isCorrect,
    required this.correctAnswer,
    this.scoreGained = 0,
    this.totalScore = 0,
    this.message,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      isCorrect: json['isCorrect'] ?? false,
      correctAnswer: json['correctAnswer'] ?? '',
      scoreGained: json['scoreGained'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCorrect': isCorrect,
      'correctAnswer': correctAnswer,
      'scoreGained': scoreGained,
      'totalScore': totalScore,
      'message': message,
    };
  }
}

/// Ranking verisi
class RankingData {
  final List<RankingItem> rankings;
  final UserRank? myRank;
  final int totalPlayers;

  const RankingData({
    this.rankings = const [],
    this.myRank,
    this.totalPlayers = 0,
  });

  factory RankingData.fromJson(Map<String, dynamic> json) {
    final rankingsList = json['rankings'] as List<dynamic>? ?? [];
    final rankings = rankingsList
        .map((item) => RankingItem.fromJson(item as Map<String, dynamic>))
        .toList();

    UserRank? myRank;
    if (json['myRank'] != null) {
      myRank = UserRank.fromJson(json['myRank'] as Map<String, dynamic>);
    }

    return RankingData(
      rankings: rankings,
      myRank: myRank,
      totalPlayers: json['totalPlayers'] ?? 0,
    );
  }
}

/// Ranking item
class RankingItem {
  final String userId;
  final String username;
  final int score;
  final int rank;
  final bool isMe;

  const RankingItem({
    required this.userId,
    required this.username,
    required this.score,
    required this.rank,
    this.isMe = false,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Anonim',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      isMe: json['isMe'] ?? false,
    );
  }
}

/// User rank
class UserRank {
  final int? rank;
  final int score;

  const UserRank({
    this.rank,
    this.score = 0,
  });

  factory UserRank.fromJson(Map<String, dynamic> json) {
    return UserRank(
      rank: json['rank'],
      score: json['score'] ?? 0,
    );
  }

  String get displayText {
    if (rank == null) return 'Sıralamada yok';
    if (rank! <= 10) return '$rank. sıra';
    return '$rank. Siz: $score puan';
  }
}