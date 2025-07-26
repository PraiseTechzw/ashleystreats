import 'package:flutter/material.dart';
import '../../data/cart_repository.dart';
import '../../../orders/data/order_repository.dart';
import '../../../orders/data/models/order_isar.dart';
import '../../../products/data/product_repository.dart';
import '../../data/models/cart_item_isar.dart';
import '../../../products/data/models/product_isar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  TimeOfDay? _deliveryTime;
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate() || _deliveryTime == null) return;
    setState(() => _isPlacingOrder = true);

    // Fetch cart items and products
    final cartRepo = CartRepository();
    final productRepo = ProductRepository();
    final cartItems = await cartRepo.getAllCartItems();
    final products = await productRepo.getAllProducts();

    // Prepare order data
    final productIds = <int>[];
    final quantities = <int>[];
    double total = 0.0;
    for (final item in cartItems) {
      productIds.add(item.productId);
      quantities.add(item.quantity);
      final matches = products.where((p) => p.id == item.productId);
      final product = matches.isEmpty ? null : matches.first;
      if (product != null) {
        total += product.price * item.quantity;
      }
    }

    final order = OrderIsar()
      ..productIds = productIds
      ..quantities = quantities
      ..total = total
      ..status = 'Pending'
      ..createdAt = DateTime.now()
      ..deliveryAddress = _addressController.text
      ..phoneNumber = _phoneController.text
      ..deliveryTime = _deliveryTime!.format(context);

    // Save order
    await OrderRepository().addOrder(order);

    // Clear cart
    await cartRepo.clearCart();

    setState(() => _isPlacingOrder = false);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placed!')));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _deliveryTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter phone number'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _deliveryTime == null
                        ? 'No delivery time selected'
                        : 'Delivery: ${_deliveryTime!.format(context)}',
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: const Text('Pick Time'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder ? null : _placeOrder,
                  child: _isPlacingOrder
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
