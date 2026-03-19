import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/core/network/api_client.dart';

/// Provides configured Dio instance for API calls.
final apiClientProvider = Provider<Dio>((ref) {
  return createApiClient();
});
