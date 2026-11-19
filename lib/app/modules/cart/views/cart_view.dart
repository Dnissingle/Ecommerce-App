import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/no_data.dart';
import '../controllers/cart_controller.dart';
import 'widgets/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  Future<void> _showCheckoutDialog() async {
    final formKey = GlobalKey<FormState>();
    final placed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delivery details'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.deliveryAddressController,
                decoration:
                    const InputDecoration(labelText: 'Delivery address'),
                minLines: 2,
                maxLines: 3,
                validator: (value) => (value?.trim().length ?? 0) < 8
                    ? 'Enter a complete address'
                    : null,
              ),
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.trim().length ?? 0) < 7
                    ? 'Enter a valid phone number'
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                'Payment is collected on delivery.',
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              if (await controller.placeOrder()) Get.back(result: true);
            },
            child: const Text('Place order'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (placed == true) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                onPressed: () => Get.back(),
                backgroundColor: theme.scaffoldBackgroundColor,
                borderColor: theme.dividerColor,
                icon: SvgPicture.asset(
                  Constants.backArrowIcon,
                  fit: BoxFit.none,
                  colorFilter: ColorFilter.mode(
                    theme.appBarTheme.iconTheme?.color ?? theme.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text('Cart 🛒', style: theme.textTheme.displaySmall),
              const Opacity(
                opacity: 0.0,
                child: CustomIconButton(onPressed: null, icon: Center()),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (_) => Column(
          children: [
            24.verticalSpace,
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.errorMessage!,
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: controller.getCartProducts,
                                  child: const Text('Try again'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : controller.products.isEmpty
                          ? const NoData(text: 'No Products in Your Cart Yet!')
                          : ListView.separated(
                              separatorBuilder: (_, index) => Padding(
                                padding:
                                    EdgeInsets.only(top: 12.h, bottom: 24.h),
                                child: const Divider(thickness: 1),
                              ),
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) => CartItem(
                                product: controller.products[index],
                              ).animate(delay: (100 * index).ms).fade().slideX(
                                    duration: 300.ms,
                                    begin: -1,
                                    curve: Curves.easeInSine,
                                  ),
                            ),
            ),
            if (controller.products.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: theme.textTheme.headlineMedium),
                    Text(
                      '\$${controller.total.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            30.verticalSpace,
            Visibility(
              visible: controller.products.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  text: 'Purchase Now',
                  onPressed: _showCheckoutDialog,
                  fontSize: 16.sp,
                  radius: 50.r,
                  verticalPadding: 16.h,
                  hasShadow: false,
                ).animate().fade().slideY(
                      duration: 300.ms,
                      begin: 1,
                      curve: Curves.easeInSine,
                    ),
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
