import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/repositories/store_repository.dart';

class CategoryController extends GetxController {
  List<CategoryModel> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading = true;
    errorMessage = null;
    update();
    try {
      categories = await StoreRepository.fetchCategories();
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}
