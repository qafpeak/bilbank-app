// lib/main.dart
import 'package:bilbank_app/core/app_theme.dart';
import 'package:bilbank_app/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_app/data/providers/user_provider.dart';
import 'package:bilbank_app/presentation/navigation/app_router.dart';
import 'package:bilbank_app/presentation/navigation/app_router_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageImpl();
  await storage.init();

  final appRouterProvider = AppRouterProvider();
  await appRouterProvider.autoLogin(); // 💡 artık senkron çalışıyor

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppRouterProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Bunu ekleyin
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.appThemeData,
      routerConfig: router(initialLocation: context.read<AppRouterProvider>().initialLocation),
      debugShowCheckedModeBanner: false,
      title: 'bilbank_app',
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

