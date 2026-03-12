import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/messaging/fcm_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'l10n/strings.g.dart';
import 'routing/app_router.dart';

/// Root app widget. Wraps MaterialApp with router, localization, theme.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouterRefreshNotifier _refreshNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _refreshNotifier = GoRouterRefreshNotifier(false);
    _router = createAppRouter(_refreshNotifier);
    _initFcm();
  }

  void _initFcm() {
    if (Firebase.apps.isEmpty) return; // Skip in tests when Firebase not initialized
    final fcm = ref.read(fcmServiceProvider);
    fcm.requestPermission();
    fcm.onMessage.listen((msg) {
      // Foreground message – log or show in-app notification
      // ignore: avoid_print
      print('FCM foreground: ${msg.notification?.title}');
    });
    fcm.onMessageOpenedApp.listen((msg) {
      // User tapped notification – handle deep link / navigate
      // ignore: avoid_print
      print('FCM opened: ${msg.data}');
    });
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);

    return authAsync.when(
      loading: () => TranslationProvider(
        child: MaterialApp(
          title: t.app.title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          locale: LocaleSettings.currentLocale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ),
      ),
      error: (_, __) => _buildAppWithRouter(false),
      data: (isLoggedIn) => _buildAppWithRouter(isLoggedIn),
    );
  }

  Widget _buildAppWithRouter(bool isLoggedIn) {
    _refreshNotifier.update(isLoggedIn);

    return TranslationProvider(
      child: MaterialApp.router(
        title: t.app.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _router,
        locale: LocaleSettings.currentLocale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
