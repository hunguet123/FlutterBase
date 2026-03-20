import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base/app/providers/auth_session_notifier.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/routing/app_routes.dart';
import 'package:flutter_base/shared/widgets/app_bar.dart';
import 'package:flutter_base/shared/widgets/app_button.dart';

/// Home screen shown after successful login.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = Translations.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: translations.home.title,
        actions: [
          IconButton(
            key: const Key('logoutIcon'),
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translations.home.welcome,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              AppButton(
                onPressed: () => _logout(context, ref),
                text: translations.home.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authSessionNotifierProvider.notifier).logout();
    if (!context.mounted) return;
    context.go(AppRoutes.login);
  }
}
