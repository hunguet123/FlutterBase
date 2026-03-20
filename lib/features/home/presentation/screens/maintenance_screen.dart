import 'package:flutter/material.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/shared/widgets/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/config/remote_config_provider.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = Translations.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: translations.app.title,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                translations.login.maintenanceError,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final remoteConfig = ref.read(remoteConfigProvider);
                  await remoteConfig.fetchAndActivate();
                  ref.invalidate(remoteConfigProvider);
                },
                child: Text(translations.maintenance.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

