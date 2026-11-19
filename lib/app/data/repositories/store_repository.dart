import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/supabase_service.dart';

class StoreRepository {
  StoreRepository._();

  static const _productColumns =
      'id, category_id, name, description, image_path, price, unit, stock_quantity, is_featured';
  static Future<void>? _anonymousSignIn;

  static SupabaseClient get _client => SupabaseService.client;

  static Future<List<CategoryModel>> fetchCategories() async {
    final rows = await _client
        .from('categories')
        .select('id, name, image_path')
        .eq('is_active', true)
        .order('sort_order');
    return rows.map(CategoryModel.fromJson).toList();
  }

  static Future<List<ProductModel>> fetchProducts({
    int? categoryId,
    String? search,
  }) async {
    var query =
        _client.from('products').select(_productColumns).eq('is_active', true);
    if (categoryId != null) query = query.eq('category_id', categoryId);
    final normalizedSearch = search?.trim();
    if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
      query = query.ilike('name', '%$normalizedSearch%');
    }
    final rows = await query.order('name');
    return rows.map((row) => ProductModel.fromJson(row)).toList();
  }

  static Future<List<ProductModel>> fetchFeaturedProducts() async {
    final rows = await _client
        .from('products')
        .select(_productColumns)
        .eq('is_active', true)
        .eq('is_featured', true)
        .order('name');
    return rows.map((row) => ProductModel.fromJson(row)).toList();
  }

  static Future<Map<int, int>> fetchCartQuantities() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return {};
    final rows = await _client
        .from('cart_items')
        .select('product_id, quantity')
        .eq('user_id', userId);
    return {
      for (final row in rows)
        (row['product_id'] as num).toInt(): (row['quantity'] as num).toInt(),
    };
  }

  static Future<void> setCartQuantity(int productId, int quantity) async {
    await ensureUserSession();
    final userId = _client.auth.currentUser!.id;
    if (quantity <= 0) {
      await _client
          .from('cart_items')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
      return;
    }
    await _client.from('cart_items').upsert(
      {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      },
      onConflict: 'user_id,product_id',
    );
  }

  static Future<List<ProductModel>> fetchCartProducts() async {
    await ensureUserSession();
    final rows = await _client
        .from('cart_items')
        .select('quantity, product:products($_productColumns)')
        .order('created_at');
    return rows
        .where((row) => row['product'] != null)
        .map((row) => ProductModel.fromJson(
              row['product'] as Map<String, dynamic>,
              quantity: (row['quantity'] as num).toInt(),
            ))
        .toList();
  }

  static Future<int> placeOrder({
    required String deliveryAddress,
    required String phone,
  }) async {
    await ensureUserSession();
    final result = await _client.rpc(
      'place_order',
      params: {
        'p_delivery_address': deliveryAddress,
        'p_phone': phone,
      },
    );
    return (result as num).toInt();
  }

  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    await ensureUserSession();
    final rows = await _client
        .from('orders')
        .select(
          'id, status, total_amount, delivery_address, phone, created_at, '
          'order_items(name, quantity, unit_price)',
        )
        .order('created_at', ascending: false);
    return rows;
  }

  static Future<void> ensureUserSession() {
    if (_client.auth.currentUser != null) return Future<void>.value();
    return _anonymousSignIn ??= _signInAnonymously();
  }

  static Future<void> _signInAnonymously() async {
    try {
      await _client.auth.signInAnonymously();
    } finally {
      _anonymousSignIn = null;
    }
  }
}
