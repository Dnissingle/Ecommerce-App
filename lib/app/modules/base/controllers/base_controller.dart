import 'package:get/get.dart';

import '../../../components/custom_snackbar.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../data/services/supabase_service.dart';
import '../../cart/controllers/cart_controller.dart';

class BaseController extends GetxController {
  // current screen index
  int currentIndex = 0;

  int cartItemsCount = 0;
  final Map<int, int> cartQuantities = {};
  bool isCartReady = false;
  String? cartError;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void changeScreen(int selectedIndex) {
    currentIndex = selectedIndex;
    update();
  }

  int quantityFor(int productId) => cartQuantities[productId] ?? 0;

  Future<void> loadCart() async {
    try {
      if (SupabaseService.isConfigured) {
        await StoreRepository.ensureUserSession();
        cartQuantities
          ..clear()
          ..addAll(await StoreRepository.fetchCartQuantities());
      }
      cartError = null;
    } on Exception catch (error) {
      cartError = error.toString();
    } finally {
      isCartReady = true;
      _updateCartCount();
    }
  }

  Future<void> onIncreasePressed(
    int productId, {
    int? maxQuantity,
  }) async {
    final quantity = quantityFor(productId);
    if (maxQuantity != null && quantity >= maxQuantity) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Out of stock',
        message: 'There are no more units of this product available.',
      );
      return;
    }
    await _saveQuantity(productId, quantity + 1);
  }

  Future<void> onDecreasePressed(int productId) async {
    final quantity = quantityFor(productId);
    if (quantity > 0) await _saveQuantity(productId, quantity - 1);
  }

  Future<void> _saveQuantity(int productId, int quantity) async {
    try {
      await StoreRepository.setCartQuantity(productId, quantity);
      if (quantity == 0) {
        cartQuantities.remove(productId);
      } else {
        cartQuantities[productId] = quantity;
      }
      cartError = null;
      _updateCartCount();
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().getCartProducts();
      }
    } on Exception catch (error) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Cart update failed',
        message: error.toString(),
      );
    }
  }

  void _updateCartCount() {
    cartItemsCount =
        cartQuantities.values.fold<int>(0, (sum, quantity) => sum + quantity);
    update(['CartBadge', 'ProductQuantity']);
  }

  Future<void> refreshCart() => loadCart();

  void resetCart() {
    cartQuantities.clear();
    update(['CartBadge']);
  }
}
