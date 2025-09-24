// services/earning_methods_service.dart
import 'package:flutter/material.dart';

import 'earning_item_model.dart';

class EarningMethodsService {
  static List<EarningMethod> getEarningMethods({required bool isFollow}) {
    final baseMethods = <EarningMethod>[
      EarningMethod(
        id: 'ads',
        title: 'Reklam İzle',
        icon: '📺',
        reward: 1,
        gradient: [Color(0xFFfa709a), Color(0xFFfee140)],
        hasTimer: true,
        hasProgress: true,
        progress: 0.66,
      ),
      if (!isFollow)
        EarningMethod(
          id: 'invite',
          title: 'Arkadaş Davet Et',
          icon: '👥',
          reward: 2,
          gradient: [Color(0xFFa8edea), Color(0xFFfed6e3)],
        ),
      EarningMethod(
        id: 'social',
        title: 'Sosyal Medya Takibi',
        icon: '📱',
        reward: 5,
        gradient: [Color(0xFFd299c2), Color(0xFFfef9d7)],
      ),
      EarningMethod(
        id: 'rate',
        title: 'Oyunu Değerlendir',
        icon: '⭐',
        reward: 5,
        gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      ),
    ];
    return baseMethods;
  }
}
