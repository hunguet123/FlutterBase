import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base/core/config/app_theme.dart';
import 'package:flutter_base/core/messaging/fcm_service.dart';
import 'package:flutter_base/features/auth/providers/auth_provider.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/routing/app_router.dart';

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
    
    // Lazy init FCM service
    if (Firebase.apps.isNotEmpty) {
      ref.read(fcmServiceProvider).init();
    }
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
      loading: () => _buildApp(
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => _buildApp(isLoggedIn: false),
      data: (isLoggedIn) => _buildApp(isLoggedIn: isLoggedIn),
    );
  }

  Widget _buildApp({bool? isLoggedIn, Widget? home}) {
    if (isLoggedIn != null) {
      _refreshNotifier.update(isLoggedIn);
    }

    final translations = t;

    final child = home != null
        ? MaterialApp(
            title: translations.app.title,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: home,
            locale: LocaleSettings.currentLocale.flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: _localizationsDelegates,
          )
        : MaterialApp.router(
            title: translations.app.title,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _router,
            locale: LocaleSettings.currentLocale.flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: _localizationsDelegates,
          );



    return TranslationProvider(child: child);
  }

  static const _localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
