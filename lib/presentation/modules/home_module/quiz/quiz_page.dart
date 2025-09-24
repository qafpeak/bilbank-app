import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/modules/home_module/quiz/widgets/spin_wheel_dialog.dart';
import 'package:bilbank_app/presentation/modules/home_module/quiz/widgets/wheel_widgets.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'models/quiz_models.dart';
import 'widgets/game_countdown_widget.dart';
import 'widgets/question_widget.dart';
import 'widgets/fortune_wheel_widget.dart';
import '../../../../data/local_storage/local_storage.dart';
import '../../../../data/local_storage/local_storage_impl.dart';
import '../../../../data/local_storage/local_storage_keys.dart';

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


    @override
  Future<int?> showSpinWheelDialog(BuildContext context) {
    return showDialog<int>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const SpinWheelDialog(),
    );
  }

  // Değişkenler sadece bir kez tanımlanmalı

  int? _lastWheelMultiplier;
  bool _showMultiplierInfo = false;

  void _handleWheelSpin() {
    final currentMultiplier = _viewModel.quizData.currentQuestion?.multiplier ?? 1;
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
                  _viewModel.sendAnswer(true, wheelMultiplier: selectedMultiplier);
                  Future.delayed(const Duration(seconds: 3), () {
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
  late QuizViewModel _viewModel;
  final LocalStorage _localStorage = LocalStorageImpl();
  static const Color primaryColor = Color(0xFF667eea);

  @override
  void initState() {
    super.initState();
    _viewModel = QuizViewModel.instance;
    _setupRankingListener();
    _initializeQuiz();
  }

  void _setupRankingListener() {
    _viewModel.addListener(() {
      if (_viewModel.quizData.rankingData != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showRankingModal(context, _viewModel.quizData.rankingData!);
          // Modal gösterildikten sonra ranking data'yı temizle
          _viewModel.clearRankingData();
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
      print('Local storage\'dan alınan token: ${finalToken.isNotEmpty ? "var" : "yok"}');
    }
    
    await _viewModel.initialize(finalToken);
    await _viewModel.joinRoom(widget.roomId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _answerSent = false;
  bool _isWheelSpinning = false;
  int _wheelBalance = 15;

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
              // Soru değiştiğinde butonları tekrar aktif et
              if (viewModel.quizData.currentQuestion != null && _answerSent) {
                
                  _answerSent = false;
              
              }
              return Column(
                children: [
                  _buildHeader(viewModel),
                  Expanded(
                    child: _buildContent(viewModel),
                  ),
                  if (viewModel.errorMessage != null)
                    _buildErrorBar(viewModel.errorMessage!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(QuizViewModel viewModel) {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: (){
                context.go(AppPageKeys.home);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiz Oyunu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Oda: ${widget.roomId}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (viewModel.quizData.score > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Skor: ${viewModel.quizData.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => viewModel.getRanking(),
              icon: const Icon(
                Icons.leaderboard,
                color: Colors.white,
                size: 24,
              ),
              tooltip: 'Sıralama',
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Modern çark bakiyesi ve animasyon
        Row(
          children: [
            GestureDetector(
              onTap: _isWheelSpinning || _wheelBalance <= 0 || _answerSent ? null : () => showSpinWheelDialog(context),
              child: AnimatedRotation(
                turns: _isWheelSpinning ? 5 : 0,
                duration: const Duration(seconds: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(_isWheelSpinning ? 0.3 : 0.15),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isWheelSpinning
                        ? [BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]
                        : [],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      // Bu kısmı değiştirin:
                      WheelWidget(
                        isSpinning: _isWheelSpinning,
                        size: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Çark: $_wheelBalance/15',
                        style: TextStyle(
                          color: _isWheelSpinning ? Colors.amber : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (_isWheelSpinning)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Bağlantı durumu
            Icon(
              viewModel.isSocketConnected 
                  ? Icons.wifi 
                  : Icons.wifi_off,
              color: viewModel.isSocketConnected 
                  ? Colors.greenAccent 
                  : Colors.redAccent,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              viewModel.isSocketConnected ? 'Bağlı' : 'Bağlanıyor...',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
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
        } else {
          return _buildWaitingScreen();
        }

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
            onWheelTap: _answerSent || _isWheelSpinning || _wheelBalance <= 0 ? null : _handleWheelSpin,
            wheelMultiplierBadge: _lastWheelMultiplier,
            showMultiplierInfo: _showMultiplierInfo,
          );
        } else {
          return _buildWaitingForQuestionScreen();
        }

      case QuizState.finished:
        return _buildFinishedScreen(viewModel);
    }
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<QuizViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  if (viewModel.isSocketConnected)
                    const Icon(
                      Icons.wifi,
                      color: Colors.green,
                      size: 32,
                    )
                  else
                    const Icon(
                      Icons.wifi_off,
                      color: Colors.red,
                      size: 32,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.isSocketConnected ? 'Bağlantı Kuruldu' : 'Bağlantı Bekleniyor...',
                    style: TextStyle(
                      color: viewModel.isSocketConnected ? Colors.green : Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          const Text(
            'Oyun başlaması bekleniyor...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Minimum katılımcı sayısı sağlandığında oyun başlayacak',
            style: TextStyle(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Consumer<QuizViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.isSocketConnected) {
                return ElevatedButton.icon(
                  onPressed: () => viewModel.retryConnection(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Bağlantıyı Yenile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForQuestionScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            'Sonraki soru bekleniyor...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedScreen(QuizViewModel viewModel) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 60,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oyun Bitti!',
              style: TextStyle(
                color: Colors.amber, // Changed to a constant color
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Final Skorunuz',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.quizData.score}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  if (viewModel.quizData.rank > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Sıralama: #${viewModel.quizData.rank}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => viewModel.retryConnection(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tekrar Oyna'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor.withOpacity(0.2),
                      foregroundColor: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Ana Sayfa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBar(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red.withOpacity(0.9),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRankingModal(BuildContext context, RankingData rankingData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🏆 Sıralama',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _viewModel.clearRankingData();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // My Rank
                if (rankingData.myRank != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rankingData.myRank!.displayText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Rankings List
                const Text(
                  'İlk 10 Sıralama',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rankingData.rankings.length,
                    itemBuilder: (context, index) {
                      final item = rankingData.rankings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: item.isMe 
                              ? Colors.yellow.withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: item.isMe 
                              ? Border.all(color: Colors.yellow, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Rank
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _getRankColor(item.rank),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '${item.rank}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Username
                            Expanded(
                              child: Text(
                                item.username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: item.isMe 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            
                            // Score
                            Text(
                              '${item.score} puan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: item.isMe 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[300]!; // Silver
      case 3:
        return Colors.orange[300]!; // Bronze
      default:
        return Colors.blue[300]!;
    }
  }
}