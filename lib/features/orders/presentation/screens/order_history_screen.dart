import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _orders = [];

  // Mock order data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'orderNo': '1001',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Delivered',
      'total': 18.50,
      'items': ['Rainbow Cupcake', 'Cheese Pie'],
    },
    {
      'orderNo': '1000',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'status': 'In Transit',
      'total': 9.00,
      'items': ['Chocolate Chip Cookie', 'Mini Quiche'],
    },
    {
      'orderNo': '0999',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'Cancelled',
      'total': 4.50,
      'items': ['Strawberry Cupcake'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _orders = _mockOrders;
      _isLoading = false;
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'in transit':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'in transit':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Orders',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/loading.json',
                width: 80,
                height: 80,
              ),
            )
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty.json',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        _statusIcon(order['status']),
                        color: _statusColor(order['status']),
                        size: 36,
                      ),
                      title: Text(
                        'Order #${order['orderNo']}',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${order['items'].join(', ')}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 13,
                              color: AppColors.secondary.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order['date'].toString().substring(0, 10)} | ${order['status']}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 12,
                              color: _statusColor(order['status']),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${order['total'].toStringAsFixed(2)}',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
