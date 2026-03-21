import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_base/core/storage/preferences_storage_contract.dart';
import 'package:flutter_base/core/storage/preferences_storage_impl.dart';

part 'preferences_storage_provider.g.dart';

/// Provider for [PreferencesStorage].
/// Async because SharedPreferences requires initialization.
@Riverpod(keepAlive: true, dependencies: [])
Future<PreferencesStorage> preferencesStorage(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesStorageImpl(prefs);
}
