import 'package:supabase_flutter/supabase_flutter.dart';

import 'store_repository.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  AuthRepository._();

  static SupabaseClient get _client => SupabaseService.client;

  static User? get currentUser => _client.auth.currentUser;

  static bool get isAnonymous => currentUser?.isAnonymous ?? true;

  static Future<void> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user?.isAnonymous == true) {
      await _client.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: {'display_name': name.trim()},
        ),
      );
      return;
    }

    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': name.trim()},
    );
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final guestCart = currentUser?.isAnonymous == true
        ? await StoreRepository.fetchCartQuantities()
        : <int, int>{};
    if (currentUser?.isAnonymous == true) {
      await _client.auth.signOut();
    }
    await _client.auth.signInWithPassword(email: email, password: password);
    if (guestCart.isNotEmpty) {
      final accountCart = await StoreRepository.fetchCartQuantities();
      for (final entry in guestCart.entries) {
        await StoreRepository.setCartQuantity(
          entry.key,
          (accountCart[entry.key] ?? 0) + entry.value,
        );
      }
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
    await _client.auth.signInAnonymously();
  }
}
