import 'package:flutter/material.dart';
import '../../../services/local_db/isar_service.dart';
import '../data/order_model.dart';
import '../../../core/constants/colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Future<OrderModel?> _latestOrderFuture;

  @override
  void initState() {
    super.initState();
    _latestOrderFuture = _getLatestOrder();
  }

  Future<OrderModel?> _getLatestOrder() async {
    final orders = await IsarService().getOrders();
    return orders.isNotEmpty ? orders.first : null;
  }

  int _statusIndex(String status) {
    switch (status) {
      case 'Delivered':
        return 2;
      case 'Preparing':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<OrderModel?>(
        future: _latestOrderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = snapshot.data;
          if (order == null) {
            return Center(
              child: Text(
                'No active orders! 🧁',
                style: TextStyle(fontSize: 20, color: AppColors.secondary),
              ),
            );
          }
          final statusIdx = _statusIndex(order.status);
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatusStep(label: 'Pending', active: statusIdx >= 0),
                    _StatusDivider(),
                    _StatusStep(label: 'Preparing', active: statusIdx >= 1),
                    _StatusDivider(),
                    _StatusStep(label: 'Delivered', active: statusIdx >= 2),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Delivery Address:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                Text(order.address, style: TextStyle(color: AppColors.button)),
                const SizedBox(height: 8),
                Text(
                  'Phone:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                Text(order.phone, style: TextStyle(color: AppColors.button)),
                const SizedBox(height: 8),
                Text(
                  'Preferred Time:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  order.deliveryTime,
                  style: TextStyle(color: AppColors.button),
                ),
                const SizedBox(height: 24),
                Text(
                  'Items:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                ...order.items.map(
                  (item) => Text(
                    '${item.name} x${item.quantity}',
                    style: TextStyle(color: AppColors.button),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Total: ₦${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label;
  final bool active;
  const _StatusStep({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: active ? AppColors.primary : AppColors.card,
          child: Icon(
            Icons.check,
            size: 16,
            color: active ? Colors.white : AppColors.button,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? AppColors.primary : AppColors.button,
          ),
        ),
      ],
    );
  }
}

class _StatusDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 2,
      color: AppColors.primary.withOpacity(0.5),
    );
  }
}
