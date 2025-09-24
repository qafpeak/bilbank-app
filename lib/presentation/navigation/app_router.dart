import 'package:bilbank_app/core/utils/vm_route.dart';
import 'package:bilbank_app/data/models/navigation/quiz_navigation_data.dart';
import 'package:bilbank_app/presentation/modules/home_module/notifications/notifications_view.dart';
import 'package:bilbank_app/presentation/modules/home_module/rules/rules_view.dart';
import 'package:bilbank_app/presentation/modules/store_module/diamond_store/diamond_store_view.dart';
import 'package:bilbank_app/presentation/modules/store_module/wheel_store/wheel_store_view.dart';
import 'package:bilbank_app/presentation/navigation/app_layout.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_view.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_view_model.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen_view_model.dart';
import 'package:bilbank_app/presentation/modules/profile_module/edit_profile/edit_profile_view.dart';
import 'package:bilbank_app/presentation/modules/profile_module/edit_profile/edit_profile_view_model.dart';
import 'package:bilbank_app/presentation/modules/profile_module/profile/profile_view.dart';
import 'package:bilbank_app/presentation/modules/profile_module/profile/profile_view_model.dart';
import 'package:bilbank_app/presentation/modules/profile_module/report_issue/report_issue_view.dart';
import 'package:bilbank_app/presentation/modules/profile_module/report_issue/report_issue_view_model.dart';
import 'package:bilbank_app/presentation/modules/home_module/quiz/quiz_page.dart';
import 'package:bilbank_app/presentation/modules/home_module/quiz/viewmodels/quiz_viewmodel.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_view.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_view_model.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/home_module/notifications/notifications_view_model.dart';

// Router'ın kullanılabilmesi için bir global navigator key tanımlanıyor
final routerKey = GlobalKey<NavigatorState>();

// GoRouter yapılandırması
GoRouter router({required String initialLocation}) => GoRouter(
  // Uygulama ilk açıldığında yönlendirilecek olan başlangıç rotası
  initialLocation: initialLocation,

  // Navigator anahtarı (bazı işlemler için dışarıdan erişim gerekir)
  navigatorKey: routerKey,

  routes: [
    vmRoute(
      path: AppPageKeys.login,
      create: (_, _) => LoginScreenViewModel(),
      child: (_, _) => const LoginPage(),
      routes: [
        vmRoute(
          path: AppPageKeys.registerAccount,
          create: (_, _) => RegisterAccountViewModel(),
          child: (_, _) => const RegisterAccountView(),
        ),
      ],
    ),


    vmRoute(
                  path: AppPageKeys.quiz,
                  create: (_, _) => QuizViewModel.instance,
                  child: (context, state) {
                    final extra = state.extra;
                    // QuizNavigationData mi yoksa String mi kontrol et
                    if (extra is QuizNavigationData) {
                      return QuizPage(
                        roomId: extra.roomId,
                        token: extra.token ?? '',
                      );
                    } else if (extra is String) {
                      // Eski format için backward compatibility
                      return QuizPage(
                        roomId: extra,
                        token: '', // Token'ı başka yerden almak gerekebilir
                      );
                    } else {
                      // Hiçbir parametre yoksa default değerler
                      return const QuizPage(
                        roomId: '',
                        token: '',
                      );
                    }
                  },
                ),

    StatefulShellRoute.indexedStack(
      branches: [
        // İlk sekme: Ana sayfa (Home)
        StatefulShellBranch(
          routes: [
            vmRoute(
              path: AppPageKeys.home,
              create: (_, _) => HomeViewModel(),
              child: (_, _) => HomeView(),
              routes: [
                
                vmRoute(
                  path: AppPageKeys.rules,
                  create: (_, _) => QuizViewModel.instance,
                  child: (context, state) {
                    return RulesView();
                  },
                ),
                vmRoute(
                      path: AppPageKeys.notifications,
                      create: (_, _) => NotificationsViewModel(),
                      child: (_, _) =>  NotificationsView(),
                    ),
              ],
            ),
          ],
        ),
        // İkinci sekme: Profil sayfası ve alt rotaları
        StatefulShellBranch(
          routes: [
            vmRoute(
              path: AppPageKeys.profile,
              create: (_,_) => ProfileViewModel(),
              child: (context, state) => const ProfileView(),
              routes: [
                vmRoute(
                  path: AppPageKeys.settings,
                  create: (_,_) => SettingsViewModel(),
                  child: (context, state) => const SettingsView(),
                  routes: [
                    vmRoute(
                      path: AppPageKeys.editProfile,
                      create: (_, _) => EditProfileViewModel(),
                      child: (_,_) => const EditProfileView(),
                    ),
                    vmRoute(
                      path: AppPageKeys.reportIssue,
                      create: (_, _) => ReportIssueViewModel(),
                      child: (_, _) => const ReportIssueView(),
                    ),
                    
                  ],
                ),
              ],
            ),
          ],
        ),

        // Üçüncü sekme: Çark marketi (Wheel Store)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPageKeys.wheel,
              builder: (context, state) =>  WheelStoreView(),
            ),
          ],
        ),

        // Dördüncü sekme: Elmas marketi (Diamond Store)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPageKeys.diamond,
              builder: (context, state) =>  DiamondStoreView(),
            ),
          ],
        ),
      ],

      // Tüm sekmeler için ortak layout (örn: BottomNavigationBar içeren widget)
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
