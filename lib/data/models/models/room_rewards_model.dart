class RoomRewardsModel {
  final String roomId;
  final String roomTitle;
  final int totalReward;
  final List<RewardTier> rewardTiers;

  RoomRewardsModel({
    required this.roomId,
    required this.roomTitle,
    required this.totalReward,
    required this.rewardTiers,
  });

  factory RoomRewardsModel.fromJson(Map<String, dynamic> json) {
    return RoomRewardsModel(
      roomId: json['room_id'] ?? '',
      roomTitle: json['room_title'] ?? '',
      totalReward: json['total_reward'] ?? 0,
      rewardTiers: (json['reward_tiers'] as List?)
          ?.map((tier) => RewardTier.fromJson(tier))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'room_title': roomTitle,
      'total_reward': totalReward,
      'reward_tiers': rewardTiers.map((tier) => tier.toJson()).toList(),
    };
  }

  // Varsayılan ödül dağıtımı hesaplama fonksiyonu
  static RoomRewardsModel calculateDefaultRewards(String roomId, String roomTitle, int totalReward) {
    // İlk 10 sıralama için ödül dağıtımı
    final List<RewardTier> tiers = [];
    
    // Toplam ödülün %100'ünü dağıt
    final List<double> percentages = [
      0.30, // 1. %30
      0.20, // 2. %20
      0.15, // 3. %15
      0.10, // 4. %10
      0.08, // 5. %8
      0.06, // 6. %6
      0.04, // 7. %4
      0.03, // 8. %3
      0.02, // 9. %2
      0.02, // 10. %2
    ];

    for (int i = 0; i < 10; i++) {
      final rank = i + 1;
      final rewardAmount = (totalReward * percentages[i]).round();
      
      tiers.add(RewardTier(
        rank: rank,
        rewardAmount: rewardAmount,
        percentage: percentages[i],
      ));
    }

    return RoomRewardsModel(
      roomId: roomId,
      roomTitle: roomTitle,
      totalReward: totalReward,
      rewardTiers: tiers,
    );
  }
}

class RewardTier {
  final int rank;
  final int rewardAmount;
  final double percentage;

  RewardTier({
    required this.rank,
    required this.rewardAmount,
    required this.percentage,
  });

  factory RewardTier.fromJson(Map<String, dynamic> json) {
    return RewardTier(
      rank: json['rank'] ?? 0,
      rewardAmount: json['reward_amount'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'reward_amount': rewardAmount,
      'percentage': percentage,
    };
  }

  String get rankDisplay {
    switch (rank) {
      case 1:
        return '🥇 1.';
      case 2:
        return '🥈 2.';
      case 3:
        return '🥉 3.';
      default:
        return '$rank.';
    }
  }
}