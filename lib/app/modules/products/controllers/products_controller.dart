import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/store_repository.dart';
import '../../base/controllers/base_controller.dart';

class ProductsController extends GetxController {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;
  int? categoryId;
  String title = 'All products';
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic>) {
      categoryId = arguments['categoryId'] as int?;
      title = arguments['title'] as String? ?? title;
    }
    loadProducts();
  }

  Future<void> loadProducts({String? search}) async {
    isLoading = true;
    errorMessage = null;
    update();
    try {
      products = await StoreRepository.fetchProducts(
        categoryId: categoryId,
        search: search,
      );
      final baseController = Get.find<BaseController>();
      for (final product in products) {
        product.quantity = baseController.quantityFor(product.id);
      }
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
