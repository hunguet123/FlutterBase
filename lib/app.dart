import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base/core/config/app_theme.dart';
import 'package:flutter_base/features/auth/providers/auth_provider.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/routing/app_router.dart';

/// Root app widget. Wraps MaterialApp with router, localization, theme.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);
    final router = ref.watch(routerProvider);

    return authAsync.when(
      loading:
          () => _buildApp(
            context,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
      error: (_, _) => _buildApp(context, router: router),
      data: (_) => _buildApp(context, router: router),
    );
  }

  Widget _buildApp(BuildContext context, {GoRouter? router, Widget? home}) {
    // Avoid calling `Translations.of(context)` before `TranslationProvider`
    // is placed in the widget tree (it throws if InheritedLocaleData
    // is not available yet).
    final translations = t;

    final child =
        home != null
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
