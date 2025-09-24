import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/local_storage/local_storage.dart';
import '../../../../data/local_storage/local_storage_impl.dart';
import '../../../../data/local_storage/local_storage_keys.dart';
import 'models/quiz_models.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'widgets/fortune_wheel_widget.dart';
import 'widgets/game_countdown_widget.dart';
import 'widgets/question_widget.dart';
import 'widgets/quiz_error_bar.dart';
import 'widgets/quiz_finished_screen.dart';
import 'widgets/quiz_header.dart';
import 'widgets/quiz_ranking_dialog.dart';
import 'widgets/quiz_waiting_for_question.dart';
import 'widgets/quiz_waiting_screen.dart';
import 'widgets/spin_wheel_dialog.dart';

class QuizPage extends StatefulWidget {
  final String roomId;
  final String token;

  const QuizPage({
    Key? key,
    required this.roomId,
    required this.token,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuizViewModel _viewModel;
  final LocalStorage _localStorage = LocalStorageImpl();

  int? _lastWheelMultiplier;
  bool _showMultiplierInfo = false;
  bool _answerSent = false;
  bool _isWheelSpinning = false;
  int _wheelBalance = 15;

  @override
  void initState() {
    super.initState();
    _viewModel = QuizViewModel.instance;
    _setupRankingListener();
    _initializeQuiz();
  }

  void _setupRankingListener() {
    _viewModel.addListener(() {
      final rankingData = _viewModel.quizData.rankingData;
      if (rankingData != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showQuizRankingDialog(
            context: context,
            rankingData: rankingData,
          ).whenComplete(() {
            _viewModel.clearRankingData();
          });
        });
      }
    });
  }

  Future<void> _initializeQuiz() async {
    String finalToken = widget.token;
    if (finalToken.isEmpty) {
      print('Token boş, local storage\'dan alınıyor...');
      finalToken = await _localStorage.getValue<String>(
        LocalStorageKeys.accessToken,
        '',
      );
      print(
        'Local storage\'dan alınan token: '
        '${finalToken.isNotEmpty ? "var" : "yok"}',
      );
    }

    await _viewModel.initialize(finalToken);
    await _viewModel.joinRoom(widget.roomId);
  }

  Future<int?> _showSpinWheelDialog(BuildContext context) {
    return showDialog<int>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const SpinWheelDialog(),
    );
  }

  void _handleWheelSpin() {
    final currentMultiplier =
        _viewModel.quizData.currentQuestion?.multiplier ?? 1;
    if (_isWheelSpinning || _wheelBalance <= 0 || _answerSent) return;
    if (currentMultiplier != 1) {
      setState(() {
        _showMultiplierInfo = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showMultiplierInfo = false;
          });
        }
      });
      return;
    }
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: FortuneWheelWidget(
                isSpinning: true,
                onResult: (selectedMultiplier) {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    _isWheelSpinning = false;
                    _answerSent = true;
                    _wheelBalance--;
                    _lastWheelMultiplier = selectedMultiplier;
                  });
                  _viewModel.sendAnswer(true,
                      wheelMultiplier: selectedMultiplier);
                  Future.delayed(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    setState(() {
                      _lastWheelMultiplier = null;
                    });
                  });
                },
              ),
            ),
          ),
        );
      },
    );
    setState(() {
      _isWheelSpinning = true;
    });
  }

  void _handleAnswer(bool answer) {
    if (!_answerSent) {
      setState(() {
        _answerSent = true;
      });
      _viewModel.sendAnswer(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: CustomGradientScaffold(
        body: SafeArea(
          child: Consumer<QuizViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.quizData.currentQuestion != null && _answerSent) {
                _answerSent = false;
              }

              final canShowWheelDialog =
                  !_isWheelSpinning && _wheelBalance > 0 && !_answerSent;

              return Column(
                children: [
                  QuizHeader(
                    roomId: widget.roomId,
                    score: viewModel.quizData.score,
                    isSocketConnected: viewModel.isSocketConnected,
                    wheelBalance: _wheelBalance,
                    isWheelSpinning: _isWheelSpinning,
                    onBack: () => context.go(AppPageKeys.home),
                    onRankingTap: viewModel.getRanking,
                    onWheelTap: canShowWheelDialog
                        ? () => _showSpinWheelDialog(context)
                        : null,
                  ),
                  Expanded(
                    child: _buildContent(viewModel),
                  ),
                  if (viewModel.errorMessage != null)
                    QuizErrorBar(message: viewModel.errorMessage!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(QuizViewModel viewModel) {
    final quizData = viewModel.quizData;

    switch (quizData.state) {
      case QuizState.waiting:
        if (quizData.countdown > 0) {
          return GameCountdownWidget(
            seconds: quizData.countdown,
            roomName: widget.roomId,
          );
        }
        return QuizWaitingScreen(
          isSocketConnected: viewModel.isSocketConnected,
          onRetryConnection: viewModel.retryConnection,
        );
      case QuizState.playing:
        if (quizData.hasQuestion) {
          return QuestionWidget(
            question: quizData.currentQuestion!,
            timeLeft: quizData.questionTimeLeft,
            onYesTap: _answerSent ? null : () => _handleAnswer(true),
            onNoTap: _answerSent ? null : () => _handleAnswer(false),
            answerSent: _answerSent,
            wheelBalance: _wheelBalance,
            isWheelSpinning: _isWheelSpinning,
            onWheelTap: _answerSent || _isWheelSpinning || _wheelBalance <= 0
                ? null
                : _handleWheelSpin,
            wheelMultiplierBadge: _lastWheelMultiplier,
            showMultiplierInfo: _showMultiplierInfo,
          );
        }
        return const QuizWaitingForQuestion();
      case QuizState.finished:
        return QuizFinishedScreen(
          score: quizData.score,
          rank: quizData.rank,
          onPlayAgain: viewModel.retryConnection,
          onReturnHome: () => Navigator.of(context).pop(),
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
