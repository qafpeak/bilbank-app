import 'package:flutter/material.dart';

import '../../../components/main/custom_gradient_scaffold.dart';
import 'rules_view_components/rule_card.dart';
import 'rules_view_components/section_header.dart';
import 'rules_view_components/intro_card.dart';
import 'rules_view_mixin.dart';

class RulesView extends StatelessWidget with RulesViewMixin {
   RulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Oyun Kuralları',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 🎯 Giriş Bilgisi
            IntroCard(),

            const SizedBox(height: 16),

            // 🧠 Oynanış ve Puanlama
            SectionHeader(title: " Oynanış ve Puanlama"),
            RuleCard(
              rules: gameplayAndScoring,
            ),

            const SizedBox(height: 16),

            // 🎯 Yarışma Odaları
            SectionHeader(title: " Yarışma Odaları"),
            RuleCard(
              rules: competitionRooms,
            ),

            const SizedBox(height: 16),

            // 🏆 Sıralama ve Ödül
            SectionHeader(title: " Sıralama ve Ödül Sistemi"),
            RuleCard(
              rules: rankingAndRewards,
            ),

            const SizedBox(height: 16),

            // 🔄 Çark Kullanımı
            SectionHeader(title: " Çark Kullanımı"),
            RuleCard(
              rules: wheelUsage,
            ),

            const SizedBox(height: 16),

            // 💎 Oyun İçi Para ve Çekim
            SectionHeader(title: " Elmas ve Çekim Politikası"),
            RuleCard(
              rules:diamondsAndWithdrawal,
            ),

            const SizedBox(height: 16),

            // ⚖️ Yasal Yükümlülükler
            SectionHeader(title: " Yasal ve Vergi Bilgileri"),
            RuleCard(
              rules: legalAndTax,
            ),

            const SizedBox(height: 16),

            // ❌ İptal ve İade
            SectionHeader(title: " İptal ve İade Şartları"),
            RuleCard(
              rules: cancellationAndRefund,
            ),

            const SizedBox(height: 16),

            // 📱 Kullanıcı Sorumlulukları
            SectionHeader(title: " Kullanıcı Sorumlulukları"),
            RuleCard(
              rules: userResponsibilities,
            ),

            const SizedBox(height: 16),

            // 🛠️ Güncelleme Hakkı
            SectionHeader(title: " Güncelleme Hakkı"),
            RuleCard(
              rules: updateRights,
            ),

            const SizedBox(height: 16),

            // 📩 Destek
            SectionHeader(title: " Destek ve İletişim"),
            RuleCard(
              rules: supportAndContact,
              isHighlighted: true,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


}

