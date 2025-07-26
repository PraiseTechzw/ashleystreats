import 'package:flutter/material.dart';
import '../../data/order_repository.dart';
import '../../data/models/order_isar.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderRepository _repo = OrderRepository();
  late Future<List<OrderIsar>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _repo.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
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
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text(
                  'Status: ${order.status}\n'
                  'Total: \$${order.total.toStringAsFixed(2)}\n'
                  'Placed: ${order.createdAt.toLocal()}',
                ),
                isThreeLine: true,
                onTap: () {
                  // Optionally show order details
                },
              );
            },
          );
        },
      ),
    );
  }
}
