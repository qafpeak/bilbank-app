class QuizNavigationData {
  final String roomId;
  final bool? hasReservation;
  final String? token;

  QuizNavigationData({
    required this.roomId,
    this.hasReservation,
    this.token,
  });
}