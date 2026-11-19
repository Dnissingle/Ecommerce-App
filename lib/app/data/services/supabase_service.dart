import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient? _client;

  static bool get isConfigured => _client != null;

  static SupabaseClient get client {
    final client = _client;
    if (client == null) {
      throw const BackendConfigurationException(
        'Supabase is not configured. Provide SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY with --dart-define.',
      );
    }
    return client;
  }

  static Future<void> initialize() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const publishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
    if (url.isEmpty || publishableKey.isEmpty) return;

    await Supabase.initialize(url: url, publishableKey: publishableKey);
    _client = Supabase.instance.client;
  }
}

class BackendConfigurationException implements Exception {
  final String message;

  const BackendConfigurationException(this.message);

  @override
  String toString() => message;
}
