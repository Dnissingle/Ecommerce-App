import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../base/controllers/base_controller.dart';

class ProductDetailsController extends GetxController {
  // get product details from arguments
  ProductModel product = Get.arguments;

  /// when the user press on add to cart button
  Future<void> onAddToCartPressed() async {
    await Get.find<BaseController>().onIncreasePressed(
      product.id,
      maxQuantity: product.stockQuantity,
    );
    Get.back();
  }
}
