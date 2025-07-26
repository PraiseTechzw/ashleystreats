import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../../features/orders/presentation/screens/order_history_screen.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Ashley';
  String _email = 'ashley@email.com';
  String _avatar = '';
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

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

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _darkModeEnabled = !_darkModeEnabled;
    });
  }

  
  void _showSettingsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTheme.girlishHeadingStyle.copyWith(
            color: AppColors.primary,
          ),
        ),
        content: Text(content),
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
      body: Stack(
        children: [
          // Soft playful background accent
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.cardColor.withOpacity(0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Gradient header with avatar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 32, bottom: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.12),
                          AppColors.cardColor.withOpacity(0.10),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.15,
                              ),
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 56,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: _editProfile,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _name,
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 26,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 15,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Profile actions grouped in a card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 0,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          _profileAction(
                            icon: Icons.edit,
                            label: 'Edit Profile',
                            color: AppColors.primary,
                            onTap: _editProfile,
                          ),
                          _profileAction(
                            icon: Icons.receipt_long,
                            label: 'My Orders',
                            color: AppColors.primary,
                            onTap: _goToOrders,
                          ),
                          _profileAction(
                            icon: Icons.location_on,
                            label: 'Delivery Address',
                            color: AppColors.primary,
                            onTap: _editAddress,
                          ),
                          _profileAction(
                            icon: Icons.logout,
                            label: 'Logout',
                            color: AppColors.accent,
                            onTap: _showLogoutDialog,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Settings section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            'Settings',
                            style: AppTheme.girlishHeadingStyle.copyWith(
                              fontSize: 20,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              _settingsAction(
                                icon: Icons.notifications,
                                label: 'Notifications',
                                color: AppColors.primary,
                                trailing: Switch(
                                  value: _notificationsEnabled,
                                  onChanged: (value) => _toggleNotifications(),
                                  activeColor: AppColors.primary,
                                ),
                              ),
                              _settingsAction(
                                icon: Icons.dark_mode,
                                label: 'Dark Mode',
                                color: AppColors.secondary,
                                trailing: Switch(
                                  value: _darkModeEnabled,
                                  onChanged: (value) => _toggleDarkMode(),
                                  activeColor: AppColors.primary,
                                ),
                              ),
                              
                              
                        
                              _settingsAction(
                                icon: Icons.privacy_tip,
                                label: 'Privacy Policy',
                                color: AppColors.primary,
                                onTap: () => _showSettingsDialog(
                                  'Privacy Policy',
                                  'Our privacy policy details how we protect your data.',
                                ),
                              ),
                              _settingsAction(
                                icon: Icons.help,
                                label: 'Help & Support',
                                color: AppColors.primary,
                                onTap: () => _showSettingsDialog(
                                  'Help & Support',
                                  'Get help with your orders and account.',
                                ),
                              ),
                              _settingsAction(
                                icon: Icons.info,
                                label: 'About',
                                color: AppColors.primary,
                                onTap: () => _showSettingsDialog(
                                  'About',
                                  'Ashley\'s Treats v1.0.0\nDelicious sweet and savory treats delivered to your doorstep!',
                                ),
                              ),
                              _settingsAction(
                                icon: Icons.description,
                                label: 'Terms of Service',
                                color: AppColors.primary,
                                onTap: () => _showSettingsDialog(
                                  'Terms of Service',
                                  'Our terms of service and usage guidelines.',
                                ),
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: AppColors.cardColor.withOpacity(0.3),
            ),
          ),
      ],
    );
  }

  Widget _settingsAction({
    required IconData icon,
    required String label,
    required Color color,
    Widget? trailing,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(fontSize: 16),
          ),
          trailing:
              trailing ??
              (onTap != null
                  ? const Icon(Icons.arrow_forward_ios, size: 16)
                  : null),
          onTap: onTap,
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: AppColors.cardColor.withOpacity(0.3),
            ),
          ),
      ],
    );
  }
}
