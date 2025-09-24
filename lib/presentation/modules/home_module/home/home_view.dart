import 'package:bilbank_app/data/models/models/room_state.dart';
import 'package:bilbank_app/data/models/models/room_model.dart';
import 'package:bilbank_app/data/models/models/room_rewards_model.dart';
import 'package:bilbank_app/presentation/components/common/decorative_divider.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_components/ads_widget/free_diamond_widget.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_components/room_card.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_components/room_state_bottom_sheet.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_components/room_rewards_bottom_sheet.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import 'package:bilbank_app/presentation/modules/home_module/home/home_view_model.dart';
import 'package:bilbank_app/data/models/navigation/quiz_navigation_data.dart';
import 'package:bilbank_app/data/providers/user_provider.dart';
import 'package:bilbank_app/data/local_storage/local_storage.dart';
import 'package:bilbank_app/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_app/data/local_storage/local_storage_keys.dart';

import 'home_components/notification_badge.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  static const double _cardsHeight = 300; // RoomCard yüksekliği + boşluk payı
  final LocalStorage _localStorage = LocalStorageImpl();

  // Token'ı al
  Future<String> _getToken() async {
    return await _localStorage.getValue<String>(LocalStorageKeys.accessToken, '');
  }

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde kullanıcı bakiyelerini güncelle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      userProvider.refreshUserBalances();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        toolbarHeight:
            kToolbarHeight + MediaQuery.sizeOf(context).height * 0.01,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NotificationBadge(
              onNotificationTap: () async {
                context.push(AppPageKeys.notificationsPath).then((_) {
                  context.read<HomeViewModel>().clearNotificationCount();
                });
              },
              notificationCount: context
                  .watch<HomeViewModel>()
                  .notificationCount,
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.chartSimple),
                ),
                Text("Başarılar", style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context.push(AppPageKeys.rulesPath);
                  },
                  icon: Icon(Icons.help),
                ),
                Text("Kurallar", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchRoomData();
              // Kullanıcı bakiyelerini de yenile
              final userProvider = context.read<UserProvider>();
              await userProvider.refreshUserBalances();
            },
            child: _buildBody(context, vm),
          );
        },
      ),
    );
  }

  // RefreshIndicator dikey scroll ister; bu yüzden içeride her durumda ListView döndürüyoruz.
  Widget _buildBody(BuildContext context, HomeViewModel vm) {
    // Yükleniyor durumu: AlwaysScrollable ile çek-yenile aktif kalsın.
    if (vm.loading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 200),
        ],
      );
    }

    // Hata durumu
    if (vm.error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(
              vm.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: vm.fetchRoomData,
              child: const Text('Tekrar Dene'),
            ),
          ),
          const SizedBox(height: 120),
        ],
      );
    }

    // Boş durum
    if (vm.rooms.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          SizedBox(height: 160),
          Center(
            child: Text(
              'Henüz oda yok',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 160),
        ],
      );
    }

    // Veri var: yatay kart listesi
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),

      children: [
        Center(
          child: Text(
            "TURNUVALAR",
            style: GoogleFonts.headlandOne(fontSize: 22, color: Colors.white),
          ),
        ),
        DecorativeDivider(),
        SizedBox(
          height: _cardsHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: vm.rooms.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (ctx, index) {
              final r = vm.rooms[index];
              return RoomCard(
                room: r,
                index: index, // Bu satırı ekleyin
                onRewardsPressed: () async {
                  // Ödül detaylarını göster
                  await _showRoomRewards(context, r);
                },
                onPressed: () async {
                  await vm.showRoomDetails(r.id ?? "");
                  if (!context.mounted) return;
                  if (vm.roomState != null) {
                    await showRoomStateBottomSheet(
                      context: context,
                      room: vm.roomState!,
                      isLoading: vm.loadingRoomState,
                      onPrimary: () async {
                        final ok = await vm.reserveRoom(r.id!);
                        if (!context.mounted) return;
                        Navigator.of(context).maybePop();
                        showResultSnack(context, ok: ok, error: vm.error);
                      },
                      onJoin: () async {
                        print('🔍 [DEBUG] onJoin clicked - reserved: ${vm.roomState?.reserved}, roomId: ${r.id}');
                        
                        // Eğer kullanıcının zaten rezervasyonu varsa direkt quiz sayfasına git
                        if (vm.roomState?.reserved == true) {
                          print('🔍 [DEBUG] User already has reservation, going to quiz page');
                          if (!mounted) return;
                          final token = await _getToken();
                          if (!mounted) return;
                          context.go(AppPageKeys.quiz, extra: QuizNavigationData(
                            roomId: r.id ?? "",
                            hasReservation: true,
                            token: token,
                          ));
                          return;
                        }
                        
                        print('🔍 [DEBUG] User does not have reservation, making reservation...');
                        // Rezervasyon yoksa önce rezervasyon yap
                        bool reserveOk = await vm.reserveRoom(r.id ?? "");
                        print('🔍 [DEBUG] Reservation result: $reserveOk');
                        if (reserveOk) {
                          // Rezervasyon başarılıysa quiz sayfasına git
                          print('🔍 [DEBUG] Reservation successful, going to quiz page');
                          if (!mounted) return;
                          final token = await _getToken();
                          context.go(AppPageKeys.quizPath, extra: QuizNavigationData(
                            roomId: r.id ?? "",
                            hasReservation: true,
                            token: token,
                          ));
                        } else {
                          print('🔍 [DEBUG] Reservation failed, showing error');
                          Navigator.of(context).maybePop();
                          showResultSnack(context, ok: reserveOk, error: vm.error);
                        }
                      },
                    );
                  } else {
                    showResultSnack(
                      context,
                      ok: false,
                      error: vm.error ?? 'Oda bilgisi alınamadı',
                    );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 30,
            child: Marquee(
              text:
                  'Odalar minimum kullanıcı sayısı tamamlandığında açılacaktır. Başvuru yaparak sayı tamamlanmasına katkı sağlayabilirsiniz. Bildirimlerinizi açık tutun; başlamadan önce bildirim alacaksınız…',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              velocity: 25,
              blankSpace: 100,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Consumer<UserProvider>(
          builder: (context, userProvider, _) => FreeDiamondsWidget(
            initialDiamonds: userProvider.balance.toInt(),
            initialWhells: userProvider.trivaBalance.toInt(),
            refreshCurrentDiamonds: () {
              userProvider.refreshUserBalances();
            },
            refreshCurrentWhells: () {
              userProvider.refreshUserBalances();
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<T?> showRoomStateBottomSheet<T>({
    required BuildContext context,
    required RoomState room,
    required bool isLoading,
    VoidCallback? onPrimary,
    VoidCallback? onJoin,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: false,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RoomStateBottomSheet(
        room: room,
        isLoading: isLoading,
        onReserve: onPrimary,
        onJoin: onJoin,
      ),
    );
  }

  Future<void> _showRoomRewards(BuildContext context, RoomModel room) async {
    // Varsayılan ödül dağıtımını hesapla
    final rewards = RoomRewardsModel.calculateDefaultRewards(
      room.id ?? '',
      room.title ?? 'Oda',
      room.reward ?? 0,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoomRewardsBottomSheet(
        room: room,
        rewards: rewards,
      ),
    );
  }

  @override
  void showResultSnack(
    BuildContext context, {
    required bool ok,
    String? error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Rezervasyon başarılı' : (error ?? 'İşlem başarısız'),
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }
}
