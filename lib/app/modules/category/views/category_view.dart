import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/category_item.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: theme.textTheme.displaySmall),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.loadCategories,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh categories',
          ),
        ],
      ),
      body: GetBuilder<CategoryController>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage != null) {
            return Center(
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
                      onPressed: controller.loadCategories,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (controller.categories.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(24.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.h,
              mainAxisExtent: 150.h,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Card(
                child: Center(child: CategoryItem(category: category)),
              );
            },
          );
        },
      ),
    );
  }
}
