import 'package:flutter/material.dart';
import '../../../products/presentation/screens/product_list_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
// import your profile screen here

class CustomerNavScreen extends StatefulWidget {
  const CustomerNavScreen({Key? key}) : super(key: key);

  @override
  State<CustomerNavScreen> createState() => _CustomerNavScreenState();
}

class _CustomerNavScreenState extends State<CustomerNavScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    ProductListScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    // ProfileScreen(), // Add your profile screen here
    Center(child: Text('Profile')), // Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
