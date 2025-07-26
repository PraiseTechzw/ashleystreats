import 'package:flutter/material.dart';
import '../../data/cart_repository.dart';
import '../../data/models/cart_item_isar.dart';
import '../../../products/data/product_repository.dart';
import '../../../products/data/models/product_isar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartRepository _cartRepo = CartRepository();
  final ProductRepository _productRepo = ProductRepository();
  late Future<List<CartItemIsar>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _cartRepo.getAllCartItems();
  }

  Future<ProductIsar?> _getProduct(int productId) async {
    final products = await _productRepo.getAllProducts();
    final matches = products.where((p) => p.id == productId);
    if (matches.isEmpty) return null;
    return matches.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: FutureBuilder<List<CartItemIsar>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }
          final cartItems = snapshot.data!;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return FutureBuilder<ProductIsar?>(
                future: _getProduct(cartItem.productId),
                builder: (context, productSnapshot) {
                  final product = productSnapshot.data;
                  if (product == null) {
                    return const ListTile(title: Text('Product not found'));
                  }
                  return ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.cake),
                    title: Text(product.name),
                    subtitle: Text(
                      'Qty: ${cartItem.quantity}  |  \$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _cartRepo.deleteCartItem(cartItem.id);
                        setState(() {
                          _cartFuture = _cartRepo.getAllCartItems();
                        });
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
