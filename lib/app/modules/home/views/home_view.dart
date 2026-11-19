import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/category_item.dart';
import '../../../components/custom_form_field.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/dark_transition.dart';
import '../../../components/product_item.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GetBuilder<HomeController>(
      id: 'Theme',
      builder: (_) => DarkTransition(
        offset: Offset(context.width, -1),
        isDark: !controller.isLightTheme,
        builder: (context, _) => Scaffold(
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_off_outlined, size: 44),
                            12.verticalSpace,
                            Text(
                              controller.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: controller.loadData,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Positioned(
                          top: -100.h,
                          child: SvgPicture.asset(
                            Constants.container,
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              theme.canvasColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        ListView(
                          children: [
                            Column(
                              children: [
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 24.w),
                                  title: Text(
                                    'Good morning',
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(fontSize: 12.sp),
                                  ),
                                  subtitle: Text(
                                    'Dear Customer',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 22.r,
                                    backgroundColor: theme.primaryColorDark,
                                    child: ClipOval(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Image.asset(Constants.avatar),
                                      ),
                                    ),
                                  ),
                                  trailing: CustomIconButton(
                                    onPressed: controller.onChangeThemePressed,
                                    backgroundColor: theme.primaryColorDark,
                                    icon: GetBuilder<HomeController>(
                                      id: 'Theme',
                                      builder: (_) => Icon(
                                        controller.isLightTheme
                                            ? Icons.dark_mode_outlined
                                            : Icons.light_mode_outlined,
                                        color:
                                            theme.appBarTheme.iconTheme?.color,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.w),
                                  child: CustomFormField(
                                    controller: controller.searchController,
                                    backgroundColor: theme.primaryColorDark,
                                    textSize: 14.sp,
                                    hint: 'Search products',
                                    hintFontSize: 14.sp,
                                    hintColor: theme.hintColor,
                                    maxLines: 1,
                                    borderRound: 60.r,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                    focusedBorderColor: Colors.transparent,
                                    isSearchField: true,
                                    onChanged: (value) =>
                                        controller.searchProducts(value ?? ''),
                                    onCanceled: () =>
                                        controller.searchProducts(''),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    prefixIcon: SvgPicture.asset(
                                      Constants.searchIcon,
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                                20.verticalSpace,
                                SizedBox(
                                  width: double.infinity,
                                  height: 158.h,
                                  child: carousel.CarouselSlider.builder(
                                    options: carousel.CarouselOptions(
                                      initialPage: 1,
                                      viewportFraction: 0.9,
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                    ),
                                    itemCount: controller.cards.length,
                                    itemBuilder:
                                        (context, itemIndex, pageViewIndex) {
                                      return Image.asset(
                                          controller.cards[itemIndex]);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (controller.cartError != null)
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                                child: Card(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.sync_problem_outlined,
                                    ),
                                    title: const Text('Cart not synced'),
                                    subtitle: Text(controller.cartError!),
                                    trailing: IconButton(
                                      onPressed: controller.retryCart,
                                      icon: const Icon(Icons.refresh),
                                      tooltip: 'Retry cart sync',
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                children: [
                                  20.verticalSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Categories 😋',
                                        style: theme.textTheme.headlineLarge,
                                      ),
                                      TextButton(
                                        onPressed: () => controller.loadData(),
                                        child: Text(
                                          'Refresh',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  16.verticalSpace,
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: controller.categories
                                          .map(
                                            (category) => Padding(
                                              padding:
                                                  EdgeInsets.only(right: 16.w),
                                              child: CategoryItem(
                                                  category: category),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.searchController.text
                                                .trim()
                                                .isEmpty
                                            ? 'Best selling 🔥'
                                            : 'Search results',
                                        style: theme.textTheme.headlineLarge,
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Get.toNamed(Routes.products),
                                        child: Text(
                                          'See all',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  16.verticalSpace,
                                  if (controller.featuredProducts.isEmpty)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text('No products found.'),
                                    )
                                  else
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.w,
                                        mainAxisSpacing: 16.h,
                                        mainAxisExtent: 214.h,
                                      ),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount:
                                          controller.featuredProducts.length < 2
                                              ? controller
                                                  .featuredProducts.length
                                              : 2,
                                      itemBuilder: (context, index) =>
                                          ProductItem(
                                        product:
                                            controller.featuredProducts[index],
                                      ),
                                    ),
                                  20.verticalSpace,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
