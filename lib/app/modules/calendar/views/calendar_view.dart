import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: theme.textTheme.displaySmall),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.loadOrders,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh orders',
          ),
        ],
      ),
      body: GetBuilder<CalendarController>(
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
                      onPressed: controller.loadOrders,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (controller.orders.isEmpty) {
            return const Center(
              child: Text('No orders yet. Your orders will appear here.'),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: controller.orders.length,
            separatorBuilder: (_, __) => 12.verticalSpace,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              final items = order['order_items'] as List<dynamic>? ?? const [];
              final createdAt =
                  DateTime.parse(order['created_at'] as String).toLocal();
              final total = (order['total_amount'] as num).toDouble();
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order #${order['id']}',
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      Text(
                        '${order['status']} • ${createdAt.toString().substring(0, 16)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      12.verticalSpace,
                      ...items.map(
                        (item) {
                          final unitPrice =
                              (item['unit_price'] as num).toDouble();
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              '${item['name']} × ${item['quantity']} '
                              '(\$${unitPrice.toStringAsFixed(2)} each)',
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        },
                      ),
                      8.verticalSpace,
                      Text(
                        order['delivery_address'] as String? ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        order['phone'] as String? ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                      8.verticalSpace,
                      const Text('Cash on delivery'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
