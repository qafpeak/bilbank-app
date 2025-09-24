import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/profile_module/profile/profile_components/avatar_card.dart';
import 'package:bilbank_app/presentation/modules/profile_module/profile/profile_components/avatar_selection_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/user_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    print('🔍 ProfileView initState başladı');
    // Kullanıcı bilgilerini localden yükle
    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      print('🔍 LocalStorage\'dan yükleniyor...');
      await userProvider.loadUserInfoFromLocal();
      
      // Eğer local storage'da bilgi yoksa backend'den çek
      if ((userProvider.firstName?.isEmpty ?? true) || 
          (userProvider.lastName?.isEmpty ?? true) ||
          (userProvider.username?.isEmpty ?? true) ||
          (userProvider.email?.isEmpty ?? true)) {
        print('🔍 LocalStorage boş, backend\'den çekiliyor...');
        await userProvider.fetchUserProfile();
      } else {
        print('🔍 LocalStorage\'da veri var, backend çağrısı yapmıyor');
      }
    });
  }

  Future<void> _showAvatarSelection(BuildContext context, UserProvider userProvider) async {
    // Avatar listesini çek
    final avatars = await userProvider.fetchAvatarList();
    
    if (!mounted) return;
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AvatarSelectionBottomSheet(
          currentAvatarId: userProvider.avatarId,
          avatars: avatars,
          isLoading: false,
          onAvatarSelected: (avatarId) async {
            // Loading durumunu göster
            setState(() {});
            
            final success = await userProvider.updateAvatar(avatarId);
            
            if (success) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil resmi başarıyla güncellendi!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil resmi güncellenirken bir hata oluştu.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final String firstName = userProvider.firstName ?? "";
        final String lastName = userProvider.lastName ?? "";
        final String username = userProvider.username ?? "";
        final String email = userProvider.email ?? "";
        final double balance = userProvider.balance;

        return SafeArea(
          child: Column(
            children: [
              /// Üst Bilgiler (Avatar, Ad, E-posta, Elmas Bilgisi)
              AvatarCard(
                avatarUrl: userProvider.getAvatarUrl(userProvider.avatarId),
                onEditAvatarTap: () => _showAvatarSelection(context, userProvider),
                onSettingsTap: () {
                  context.go(AppPageKeys.settingsPath);
                }
              ),
              const SizedBox(height: 16),
              Text(
                '$firstName $lastName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '@$username',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.green.withAlpha(100),
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svg/ic_diamond.svg', width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${balance.toStringAsFixed(0)} Adet',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),        
            ],
          ),
        );
      },
    );
  }
}


