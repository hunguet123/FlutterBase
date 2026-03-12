import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/strings.g.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/providers/auth_provider.dart';

/// Home screen shown after successful login.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (!context.mounted) return;
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          t.home.welcome,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
