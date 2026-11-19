import 'package:get/get.dart';

import '../../../data/repositories/store_repository.dart';

class CalendarController extends GetxController {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading = true;
    update();
    try {
      orders = await StoreRepository.fetchOrders();
      errorMessage = null;
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}
