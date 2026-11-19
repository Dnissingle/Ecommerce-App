import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_snackbar.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/store_repository.dart';
import '../../base/controllers/base_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';

class CartController extends GetxController {
  final List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;
  final deliveryAddressController = TextEditingController();
  final phoneController = TextEditingController();

  double get total => products.fold<double>(
        0,
        (sum, product) => sum + product.price * product.quantity,
      );

  @override
  void onInit() {
    super.onInit();
    getCartProducts();
  }

  Future<void> getCartProducts() async {
    isLoading = true;
    update();
    try {
      products
        ..clear()
        ..addAll(await StoreRepository.fetchCartProducts());
      errorMessage = null;
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> placeOrder() async {
    if (deliveryAddressController.text.trim().length < 8) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Address required',
        message: 'Enter a complete delivery address.',
      );
      return false;
    }
    if (phoneController.text.trim().length < 7) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Phone required',
        message: 'Enter a valid phone number.',
      );
      return false;
    }

    try {
      final orderId = await StoreRepository.placeOrder(
        deliveryAddress: deliveryAddressController.text,
        phone: phoneController.text,
      );
      products.clear();
      await Get.find<BaseController>().refreshCart();
      await getCartProducts();
      if (Get.isRegistered<CalendarController>()) {
        await Get.find<CalendarController>().loadOrders();
      }
      CustomSnackBar.showCustomSnackBar(
        title: 'Order placed',
        message: 'Your order #$orderId was received.',
      );
      return true;
    } on Exception catch (error) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Could not place order',
        message: error.toString(),
      );
      return false;
    }
  }

  @override
  void onClose() {
    deliveryAddressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
