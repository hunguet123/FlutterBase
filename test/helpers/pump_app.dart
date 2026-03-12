import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/app.dart';

/// Pumps the app wrapped with [ProviderScope] and optional overrides.
Future<void> pumpAppWithProviders(
  WidgetTester tester, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? [],
      child: const App(),
    ),
  );
}
