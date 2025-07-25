import 'package:flutter/material.dart';
import '../../../services/local_db/isar_service.dart';
import '../data/order_model.dart';
import '../../../core/constants/colors.dart';

class AdminOrdersDashboardScreen extends StatefulWidget {
  const AdminOrdersDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersDashboardScreen> createState() =>
      _AdminOrdersDashboardScreenState();
}

class _AdminOrdersDashboardScreenState
    extends State<AdminOrdersDashboardScreen> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _ordersFuture = IsarService().getOrders();
    });
  }

  Future<void> _updateStatus(OrderModel order, String newStatus) async {
    final updated = OrderModel.full(
      id: order.id,
      items: order.items,
      total: order.total,
      address: order.address,
      phone: order.phone,
      deliveryTime: order.deliveryTime,
      status: newStatus,
      createdAt: order.createdAt,
    );
    await IsarService().addOrder(updated);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Orders Dashboard'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'No orders yet! 🧁',
                style: TextStyle(fontSize: 20, color: AppColors.secondary),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            order.status,
                            style: TextStyle(
                              color: order.status == 'Delivered'
                                  ? Colors.green
                                  : order.status == 'Preparing'
                                  ? Colors.orange
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Placed: ${order.createdAt.toLocal().toString().split(".")[0]}',
                        style: TextStyle(color: AppColors.button),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: ₦${order.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Items: ${order.items.map((e) => "${e.name} x${e.quantity}").join(", ")}',
                        style: TextStyle(color: AppColors.button),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (order.status == 'Pending')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.background,
                              ),
                              onPressed: () =>
                                  _updateStatus(order, 'Preparing'),
                              child: const Text('Mark as Preparing'),
                            ),
                          if (order.status == 'Preparing')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  _updateStatus(order, 'Delivered'),
                              child: const Text('Mark as Delivered'),
                            ),
                        ],
                      ),
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
