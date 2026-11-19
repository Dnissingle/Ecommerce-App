import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/store_repository.dart';
import '../../base/controllers/base_controller.dart';

class HomeController extends GetxController {
  // to hold categories & products
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<ProductModel> featuredProducts = [];
  final searchController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;
  String? cartError;
  Timer? _searchTimer;

  // for app theme
  var isLightTheme = MySharedPref.getThemeIsLight();

  // for home screen cards
  var cards = [Constants.card1, Constants.card2, Constants.card3];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    update();
    try {
      final baseController = Get.find<BaseController>();
      await baseController.loadCart();
      cartError = baseController.cartError;
      categories = await StoreRepository.fetchCategories();
      products = await StoreRepository.fetchProducts();
      featuredProducts = await StoreRepository.fetchFeaturedProducts();
      _applyCartQuantities();
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  void searchProducts(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 350), () async {
      try {
        products = await StoreRepository.fetchProducts(search: value);
        featuredProducts = value.trim().isEmpty
            ? await StoreRepository.fetchFeaturedProducts()
            : products;
        _applyCartQuantities();
        errorMessage = null;
      } on Exception catch (error) {
        errorMessage = error.toString();
      }

      update();
    });
  }

  Future<void> retryCart() async {
    final baseController = Get.find<BaseController>();
    await baseController.loadCart();
    cartError = baseController.cartError;
    update();
  }

  void _applyCartQuantities() {
    final baseController = Get.find<BaseController>();
    for (final product in products) {
      product.quantity = baseController.quantityFor(product.id);
    }
    for (final product in featuredProducts) {
      product.quantity = baseController.quantityFor(product.id);
    }
  }

  /// when the user press on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update(['Theme']);
    update();
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
