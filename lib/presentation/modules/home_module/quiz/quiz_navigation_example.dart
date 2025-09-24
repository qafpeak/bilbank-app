import 'package:bilbank_app/data/models/navigation/quiz_navigation_data.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../quiz/quiz_page.dart';

/// Yeni quiz sistemini nasıl kullanacağınızın örneği
/// 
/// Kullanım:
/// ```dart
/// // "Odaya Git" butonuna tıklandığında:
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => QuizPage(
///       roomId: 'room123', // Backend'den gelen oda ID'si
///       token: 'user_token_here', // Kullanıcı token'ı
///     ),
///   ),
/// );
/// ```

class QuizNavigationHelper {
  /// Quiz sayfasına yönlendirme
  static void navigateToQuiz({
    required BuildContext context,
    required String roomId,
    required String userToken,
  }) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => QuizPage(
    //       roomId: roomId,
    //       token: userToken,
    //     ),
    //   ),
    // );
    context.go(AppPageKeys.quiz, extra: QuizNavigationData(roomId: roomId, token: userToken));
  }

  /// Quiz sayfasına modal olarak yönlendirme
  static void showQuizModal({
    required BuildContext context,
    required String roomId,
    required String userToken,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuizPage(
        roomId: roomId,
        token: userToken,
      ),
    );
  }
}

/// Socket event'lerini dinlemek için örnek widget
class RoomJoinExample extends StatelessWidget {
  final String roomId;
  final String userToken;

  const RoomJoinExample({
    Key? key,
    required this.roomId,
    required this.userToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Yeni quiz sistemini kullan
        QuizNavigationHelper.navigateToQuiz(
          context: context,
          roomId: roomId,
          userToken: userToken,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Odaya Git',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}