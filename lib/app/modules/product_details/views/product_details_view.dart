import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/product_count_item.dart';
import '../../../components/store_image.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 330.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      Constants.container,
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                        theme.cardColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24.h,
                    left: 24.w,
                    right: 24.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () => Get.back(),
                          icon: SvgPicture.asset(
                            Constants.backArrowIcon,
                            fit: BoxFit.none,
                            colorFilter: ColorFilter.mode(
                              theme.appBarTheme.iconTheme?.color ??
                                  theme.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            Constants.searchIcon,
                            fit: BoxFit.none,
                            colorFilter: ColorFilter.mode(
                              theme.appBarTheme.iconTheme?.color ??
                                  theme.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 80.h,
                    left: 0,
                    right: 0,
                    child: StoreImage(
                      source: controller.product.image,
                      width: 250.w,
                      height: 225.h,
                    ).animate().fade().scale(
                          duration: 800.ms,
                          curve: Curves.fastOutSlowIn,
                        ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    controller.product.name,
                    style: theme.textTheme.displayMedium,
                  ).animate().fade().slideX(
                        duration: 300.ms,
                        begin: -1,
                        curve: Curves.easeInSine,
                      ),
                  const Spacer(),
                  ProductCountItem(product: controller.product)
                      .animate()
                      .fade(duration: 200.ms),
                ],
              ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                '${controller.product.unit}, ${controller.product.price.toStringAsFixed(2)}\$',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                controller.product.description,
                style: theme.textTheme.bodyLarge,
              ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
            ),
            12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Icon(
                    controller.product.stockQuantity > 0
                        ? Icons.inventory_2_outlined
                        : Icons.remove_shopping_cart_outlined,
                    color: controller.product.stockQuantity > 0
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.error,
                  ),
                  8.horizontalSpace,
                  Text(
                    controller.product.stockQuantity > 0
                        ? '${controller.product.stockQuantity} available'
                        : 'Out of stock',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: controller.product.stockQuantity > 0
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                text: 'Add to cart',
                onPressed: () => controller.onAddToCartPressed(),
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
            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
