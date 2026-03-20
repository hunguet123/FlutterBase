import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base/app/events/app_event.dart';
import 'package:flutter_base/app/events/app_event_notifier.dart';
import 'package:flutter_base/app/session/auth_session_notifier.dart';
import 'package:flutter_base/core/theme/app_theme.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/routing/app_router.dart';
import 'package:flutter_base/routing/app_routes.dart';

/// Root app widget. Wraps MaterialApp with router, localization, theme.
/// Also handles app-level events emitted by feature screens.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authSessionNotifierProvider);
    final router = ref.watch(routerProvider);

    ref.listen<AppEvent?>(appEventNotifierProvider, (_, event) async {
      switch (event) {
        case LogoutRequested():
          await ref.read(authSessionNotifierProvider.notifier).logout();
          router.go(AppRoutes.login);
        case null:
          break;
      }
    });

    return authAsync.when(
      loading: () => _buildApp(
        context,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (_, _) => _buildApp(context, router: router),
      data: (_) => _buildApp(context, router: router),
    );
  }

  Widget _buildApp(BuildContext context, {GoRouter? router, Widget? home}) {
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
            routerConfig: router,
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
