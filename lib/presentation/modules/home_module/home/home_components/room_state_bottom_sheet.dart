import 'package:bilbank_app/data/models/models/room_state.dart';
import 'package:flutter/material.dart';


// Ana BottomSheet Widget'ı
@immutable
class RoomStateBottomSheet extends StatelessWidget {
  final RoomState room;
  final bool isLoading;
  final VoidCallback? onReserve;
  final VoidCallback? onJoin;
  final VoidCallback? onClose;
  final String? primaryButtonText;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;

  const RoomStateBottomSheet({
    super.key,
    required this.room,
    required this.isLoading,
    this.onReserve,
    this.onJoin,
    this.onClose,
    this.primaryButtonText,
    this.showCloseButton = true,
    this.padding,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? mediaQuery.size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            // Ana içerik
            _buildContent(context, theme),
            
            // Loading overlay
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'İşleniyor...',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        _buildHandle(theme),
        
        // Header
        _buildHeader(context, theme),
        
        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: _buildBody(theme),
          ),
        ),
        
        // Footer
        _buildFooter(context, theme),
      ],
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14).copyWith(bottom: 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              room.title ?? 'Oda',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showCloseButton)
            IconButton(
              tooltip: 'Kapat',
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          // Room Info Grid
          _RoomInfoGrid(room: room),
          
          const SizedBox(height: 20),
          
          // Status Chip
          Align(
            alignment: Alignment.centerLeft,
            child: _StatusChip(
              reserved: room.reserved??false,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    final reserved = room.reserved == true;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14).copyWith(top: 0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          onPressed: reserved ? onJoin : onReserve,
          child: Text(
            primaryButtonText ?? (reserved ? 'Odaya Git' : 'Randevu Oluştur'),
          ),
        ),
      ),
    );
  }

  // Helper methods için extension veya static methodlar
  static String getRoomTypeLabel(int? type) {
    switch (type) {
      case 1:
        return 'Klasik';
      case 2:
        return 'Turnuva';
      case 3:
        return 'Hızlı';
      case 4:
        return 'Özel';
      default:
        return 'Bilinmiyor';
    }
  }

  static String getRoomStatusLabel(int? status) {
    switch (status) {
      case 0:
        return 'Beklemede';
      case 1:
        return 'Aktif';
      case 2:
        return 'Kapalı';
      case 3:
        return 'Dolu';
      default:
        return 'Bilinmiyor';
    }
  }

  static Color getRoomStatusColor(int? status, ColorScheme colorScheme) {
    switch (status) {
      case 0:
        return colorScheme.secondary; // Beklemede - sarı/turuncu
      case 1:
        return colorScheme.primary; // Aktif - yeşil/mavi
      case 2:
        return colorScheme.error; // Kapalı - kırmızı
      case 3:
        return colorScheme.outline; // Dolu - gri
      default:
        return colorScheme.onSurface.withOpacity(0.5);
    }
  }

}

// Room Info Grid Widget
class _RoomInfoGrid extends StatelessWidget {
  final RoomState room;

  const _RoomInfoGrid({required this.room});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                icon: Icons.emoji_events,
                label: 'Ödül',
                value: '${room.reward ?? 0}',
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                icon: Icons.attach_money,
                label: 'Giriş Ücreti',
                value: '${room.entryFee ?? 0}',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                icon: Icons.group,
                label: 'Maks. Kullanıcı',
                value: '${room.maxUsers ?? 0}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                icon: Icons.bookmark_added,
                label: 'Aktif Rezervasyon',
                value: '${room.activeReservationCount ?? 0}',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.category,
          label: 'Oda Tipi',
          value: RoomStateBottomSheet.getRoomTypeLabel(room.roomType),
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.flag,
          label: 'Durum',
          value: RoomStateBottomSheet.getRoomStatusLabel(room.roomStatus),
        ),
      ],
    );
  }
}

// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color?.withOpacity(0.1) ?? theme.colorScheme.surfaceVariant;
    final iconColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Status Chip Widget
class _StatusChip extends StatelessWidget {
  final bool reserved;
  final ThemeData theme;

  const _StatusChip({
    required this.reserved,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        reserved ? Icons.check_circle : Icons.info_outline,
        size: 20,
        color: reserved
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
      ),
      label: Text(
        reserved ? 'Rezerve Edildi' : 'Rezerve Değil',
        style: theme.textTheme.labelMedium,
      ),
      backgroundColor: (reserved
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary)
          .withOpacity(0.08),
      side: BorderSide.none,
    );
  }
}
