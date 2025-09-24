import 'package:bilbank_app/presentation/components/common/gradient_button.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_components/purchase_bottom_sheet.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_components/settings_section.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_components/settings_tile.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsViewMixin {


  

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
            floating: true,
            snap: true,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                const SizedBox(height: 20),
      
                // Hesap
                SettingsSection(
                  title: 'Hesap',
                  children: [
                    SettingsTile(
                      icon: Icons.person_outline,
                      title: 'Profil Bilgileri',
                      subtitle: 'Ad, e‑posta, telefon',
                      onTap: () {
                        context.go(AppPageKeys.editProfilePath);
                      },
                    ),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Şifre & Güvenlik',
                      subtitle: 'Şifre değiştir, 2FA',
                      onTap: () {
                       // context.go(AppPages.changePasswordPath);
                      },
                    ),
                  ],
                ),
      
                const SizedBox(height: 20),
      
                // Gizlilik
                SettingsSection(
                  title: 'Gizlilik',
                  children: [
                    SettingsTile(
                      icon: Icons.verified_user_outlined,
                      title: 'KVKK & İzinler',
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.history_outlined,
                      title: 'Hesap Verilerini İndir',
                      onTap: () {},
                    ),
                  ],
                ),
      
                const SizedBox(height: 20),
      
                // Hakkında
                SettingsSection(
                  title: 'Hakkında',
                  children: [
                    SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Kullanım Koşulları',
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Gizlilik Politikası',
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.info_outline,
                      title: 'Sürüm',
                      trailing: const Text(
                        'v1.0.0',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: null, // sadece görüntülemek için
                    ),
                  ],
                ),
      
                const SizedBox(height: 20),
      
                SettingsSection(
                  title: 'Sorun Bildir',
                  children: [
                    SettingsTile(
                      icon: Icons.report,
                      title: 'Sorun Bildir',
                      onTap: ()async {
                        context.push(AppPageKeys.reportIssuePath);
                      },
                    ),
                  ],
                ),
      
                const SizedBox(height: 20),
      
                // Reklamlar Bölümü - Switch ile
                SettingsSection(
                  title: 'Reklamlar',
                  children: [
                    SettingsTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Reklamları Gizle',
                      trailing: Switch(
                        value: adsHidden,
                        onChanged: (bool value) {
                          if (value && !adsHidden) {
                            // Kullanıcı switch'i açmaya çalıştığında satın alma ekranını göster
                            showPurchaseBottomSheet();
                          } else if (!value && adsHidden) {
                            // Switch'i kapatmaya izin ver
                            setState(() {
                              adsHidden = false;
                            });
                          }
                        },
                        activeColor: Colors.blue,
                      ),
                      onTap: () {
                        if (!adsHidden) {
                          // Switch açık değilse satın alma ekranını göster
                          showPurchaseBottomSheet();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GradientButton(
                    text: 'Çıkış Yap',
                    icon: Icons.logout,
                    onTap: logout,
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void showPurchaseBottomSheet() {
   showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PurchaseBottomSheet(onPurchase:processPurchase);
      },
    );
  }
}
