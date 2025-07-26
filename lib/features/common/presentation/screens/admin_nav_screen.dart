import 'package:flutter/material.dart';

import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../admin/presentation/screens/admin_product_management_screen.dart';


class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({Key? key}) : super(key: key);

  @override
  State<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    AdminDashboardScreen(),
    AdminProductManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Admin Menu')),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Products'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            // Add logout or other admin options here
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
