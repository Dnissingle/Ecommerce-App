import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../data/models/category_model.dart';
import '../routes/app_pages.dart';
import 'store_image.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  const CategoryItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.products,
        arguments: {'categoryId': category.id, 'title': category.title},
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 37.r,
            backgroundColor: theme.cardColor,
            child: StoreImage(source: category.image),
          ).animate().fade(duration: 200.ms),
          10.verticalSpace,
          Text(category.title, style: theme.textTheme.titleLarge)
              .animate()
              .fade()
              .slideY(
                duration: 200.ms,
                begin: 1,
                curve: Curves.easeInSine,
              ),
        ],
      ),
    );
  }
}
