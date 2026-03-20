import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/app/events/app_event.dart';
import 'package:flutter_base/app/events/app_event_notifier.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/shared/widgets/app_bar.dart';
import 'package:flutter_base/shared/widgets/app_button.dart';

/// Home screen shown after successful login.
/// Emits [AppEvent]s for app-level actions — does not depend on auth directly.
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
            onPressed: () => _requestLogout(ref),
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
                onPressed: () => _requestLogout(ref),
                text: translations.home.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestLogout(WidgetRef ref) {
    ref.read(appEventNotifierProvider.notifier).emit(const LogoutRequested());
  }
}
