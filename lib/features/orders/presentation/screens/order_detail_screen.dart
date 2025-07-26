import 'package:flutter/material.dart';
import '../../data/models/order_isar.dart';
import '../../../products/data/product_repository.dart';
import '../../../products/data/models/product_isar.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderIsar order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ProductRepository _productRepo = ProductRepository();
  late Future<List<ProductIsar>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productRepo.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: FutureBuilder<List<ProductIsar>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Status: ${order.status}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('Delivery: ${order.deliveryAddress}'),
                Text('Phone: ${order.phoneNumber}'),
                Text('Time: ${order.deliveryTime}'),
                const Divider(),
                Text('Items:', style: Theme.of(context).textTheme.titleMedium),
                ...List.generate(order.productIds.length, (i) {
                  final matches = products.where(
                    (p) => p.id == order.productIds[i],
                  );
                  final product = matches.isEmpty ? null : matches.first;
                  if (product == null) return const SizedBox();
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Qty: ${order.quantities[i]}'),
                    trailing: Text(
                      '\$${(product.price * order.quantities[i]).toStringAsFixed(2)}',
                    ),
                  );
                }),
                const Divider(),
                Text(
                  'Total: \$${order.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text('Placed: ${order.createdAt.toLocal()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
