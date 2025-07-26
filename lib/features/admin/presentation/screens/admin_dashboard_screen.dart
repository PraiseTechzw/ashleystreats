import 'package:flutter/material.dart';
import '../../../orders/data/order_repository.dart';
import '../../../orders/data/models/order_isar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OrderRepository _orderRepo = OrderRepository();
  late Future<List<OrderIsar>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderRepo.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: FutureBuilder<List<OrderIsar>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }
          final orders = snapshot.data!;
          final today = DateTime.now();
          final ordersToday = orders
              .where(
                (o) =>
                    o.createdAt.year == today.year &&
                    o.createdAt.month == today.month &&
                    o.createdAt.day == today.day,
              )
              .toList();
          final revenueToday = ordersToday.fold<double>(
            0.0,
            (sum, o) => sum + o.total,
          );

          return ListView(
            children: [
              ListTile(
                title: const Text('Orders Today'),
                trailing: Text('${ordersToday.length}'),
              ),
              ListTile(
                title: const Text('Revenue Today'),
                trailing: Text('\$${revenueToday.toStringAsFixed(2)}'),
              ),
              const Divider(),
              ...orders.map(
                (order) => ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text(
                    'Status: ${order.status} | Total: \$${order.total.toStringAsFixed(2)}',
                  ),
                  trailing: order.status != 'Completed'
                      ? ElevatedButton(
                          onPressed: () async {
                            order.status = 'Completed';
                            await _orderRepo.addOrder(order);
                            setState(() {
                              _ordersFuture = _orderRepo.getAllOrders();
                            });
                          },
                          child: const Text('Mark Completed'),
                        )
                      : const Icon(Icons.check, color: Colors.green),
                  onTap: () {
                    // Optionally show order details
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
