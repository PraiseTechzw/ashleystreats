import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/cart_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../services/local_db/isar_service.dart';
import '../../orders/data/order_model.dart';
import '../../../core/constants/app_routes.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  TimeOfDay? _deliveryTime;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _deliveryTime = picked);
    }
  }

  void _submit() async {
    final cartItems = ref.read(cartProvider);
    if (_formKey.currentState!.validate() &&
        _deliveryTime != null &&
        cartItems.isNotEmpty) {
      final orderItems = cartItems
          .map(
            (item) => OrderItemEmbedded.full(
              productId: item.productId,
              name: item.name,
              price: item.price,
              quantity: item.quantity,
              image: item.image,
            ),
          )
          .toList();
      final total = cartItems.fold(
        0.0,
        (sum, item) => sum + item.price * item.quantity,
      );
      final order = OrderModel.full(
        items: orderItems,
        total: total,
        address: _addressController.text,
        phone: _phoneController.text,
        deliveryTime: _deliveryTime!.format(context),
        status: 'Pending',
        createdAt: DateTime.now(),
      );
      await IsarService().addOrder(order);
      await ref.read(cartProvider.notifier).clearCart();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.orderConfirmation);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order placed!')));
      }
    } else if (_deliveryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery time.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = cartItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Address',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter delivery address'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.length < 8
                          ? 'Enter a valid phone number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _deliveryTime == null
                                ? 'No delivery time selected'
                                : 'Preferred Time: ${_deliveryTime!.format(context)}',
                            style: TextStyle(color: AppColors.button),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickTime,
                          child: const Text('Select Time'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),
              ...cartItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.name} x${item.quantity}',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                      Text(
                        '₦${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(color: AppColors.button),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    '₦${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
