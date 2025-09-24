import 'package:bilbank_app/data/models/models/room_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoomCard extends StatefulWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.onPressed,
    this.index = 0,
    this.onRewardsPressed,
  });

  final RoomModel room;
  final VoidCallback onPressed;
  final VoidCallback? onRewardsPressed;
  final int index;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _hoverController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isRewardsExpanded = false;

  // Gradient renk setleri - her kart için farklı
  static const List<List<Color>> gradientColors = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Mor-Mavi
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pembe-Kırmızı
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Mavi-Cyan
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Yeşil-Turkuaz
    [Color(0xFFfa709a), Color(0xFFfee140)], // Pembe-Sarı
    [Color(0xFF30cfd0), Color(0xFFa8edea)], // Turkuaz-Açık Mavi
    [Color(0xFFa8edea), Color(0xFFfed6e3)], // Açık Mavi-Açık Pembe
    [Color(0xFF6a11cb), Color(0xFF2575fc)], // Mor-Mavi Koyu
    [Color(0xFFffecd2), Color(0xFFfcb69f)], // Krem-Turuncu
    [Color(0xFF74b9ff), Color(0xFF0984e3)], // Açık Mavi-Koyu Mavi
  ];

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  List<Color> get currentGradient {
    return gradientColors[widget.index % gradientColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProgress = (widget.room.activeReservationCount ?? 0) / 
                       math.max((widget.room.maxUsers ?? 1), 1);

    return AnimatedBuilder(
      animation: Listenable.merge([_shimmerAnimation, _pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) => _hoverController.reverse(),
            onTapCancel: () => _hoverController.reverse(),
            onTap: widget.onPressed,
            child: Container(
              width: 240,
              height: 280,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: currentGradient[0].withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Ana gradient background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: currentGradient,
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),

                  // Shimmer efekti
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Transform.translate(
                        offset: Offset(_shimmerAnimation.value * 100, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // İçerik
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık ve tip badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.room.title ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildTypeBadge(theme),
                            const SizedBox(width: 4),
                            _buildRewardsButton(),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Ödül kartı
                        _buildInfoCard(
                          icon: '💎',
                          label: 'Ödül',
                          value: '${widget.room.reward ?? 0}',
                          theme: theme,
                        ),

                        const SizedBox(height: 8),

                        // Giriş ücreti kartı
                        _buildInfoCard(
                          icon: '💰',
                          label: 'Giriş',
                          value: '${widget.room.entryFee ?? 0}',
                          theme: theme,
                        ),

                        const SizedBox(height: 12),

                        // Kullanıcı progress bar
                        _buildUserProgress(userProgress, theme),

                        const Spacer(),

                        // Katıl butonu
                        _buildJoinButton(theme, userProgress),
                      ],
                    ),
                  ),

                  // Pulse border efekti
                  Positioned.fill(
                    child: Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        widget.room.roomType?.label ?? "-",
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProgress(double progress, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.people,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Katılımcılar',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.room.activeReservationCount ?? 0}/${widget.room.maxUsers ?? 0}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white.withOpacity(0.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinButton(ThemeData theme, double userProgress) {
    final isAlmostFull = userProgress > 0.8;
    
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isAlmostFull
              ? [Colors.orange, Colors.deepOrange]
              : [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAlmostFull) ...[
                  const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  isAlmostFull ? 'Hızlı Katıl!' : 'Katıl',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _isRewardsExpanded = !_isRewardsExpanded;
            });
            widget.onRewardsPressed?.call();
          },
          child: AnimatedRotation(
            turns: _isRewardsExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}