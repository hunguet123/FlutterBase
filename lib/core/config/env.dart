import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides safe access to environment variables loaded via flutter_dotenv.
abstract final class Env {
  Env._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
