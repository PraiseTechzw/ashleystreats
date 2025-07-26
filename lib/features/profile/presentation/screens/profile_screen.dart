import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../../features/orders/presentation/screens/order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Ashley';
  String _email = 'ashley@email.com';
  String _avatar = '';

  void _editProfile() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: _name);
        final emailController = TextEditingController(text: _email);
        return AlertDialog(
          title: Text(
            'Edit Profile',
            style: AppTheme.girlishHeadingStyle.copyWith(
              color: AppColors.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'email': emailController.text,
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTheme.girlishHeadingStyle.copyWith(color: AppColors.accent),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _goToOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
    );
  }

  void _editAddress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Address',
          style: AppTheme.girlishHeadingStyle.copyWith(
            color: AppColors.primary,
          ),
        ),
        content: const Text('Address editing coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 24,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _email,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                color: AppColors.secondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.edit, color: AppColors.primary),
              title: Text('Edit Profile', style: AppTheme.elegantBodyStyle),
              onTap: _editProfile,
            ),
            ListTile(
              leading: Icon(Icons.receipt_long, color: AppColors.primary),
              title: Text('My Orders', style: AppTheme.elegantBodyStyle),
              onTap: _goToOrders,
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: AppColors.primary),
              title: Text('Delivery Address', style: AppTheme.elegantBodyStyle),
              onTap: _editAddress,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.accent),
              title: Text(
                'Logout',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.accent,
                ),
              ),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }
}
