
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color lime = Color(0xFF75F54A);
  static const Color darkGreen = Color(0xFF176B35);
  static const Color textColor = Color(0xFF20231F);
  static const Color mutedColor = Color(0xFF858A83);

  final String name = 'Alex Morgan';
  final String email = 'alexmorgan@gmail.com';

  bool notificationsEnabled = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF252A24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _openFeature(String title, IconData icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7E3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: lime.withValues(alpha: 0.17),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: darkGreen,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$title will be available here once this section is connected.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: mutedColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lime,
                    foregroundColor: textColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _openFeature(title, icon),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEDF0EA),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 57,
              width: 57,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 18,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF737B79),
            ),
            const SizedBox(width: 19),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Color(0xFF858B88),
                ),
          ],
        ),
      ),
    );
  }

  Widget _menuDivider() {
    return const Divider(
      height: 1,
      thickness: 0.8,
      indent: 62,
      endIndent: 18,
      color: Color(0xFFEDF0EC),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Logout?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showMessage(
                  'Connect authentication to enable logout.',
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width > 600 ? 32.0 : 18.0;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 650,
                  ),
                  child: Column(
                    children: [
                      // Top navigation
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          12,
                          8,
                          12,
                          0,
                        ),
                        child: SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).maybePop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 19,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Profile',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _openFeature(
                                  'Settings',
                                  Icons.settings_outlined,
                                ),
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  size: 23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Profile header
                      SizedBox(
                        height: 285,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: ProfileHeaderPainter(),
                              ),
                            ),

                            Positioned(
                              top: 22,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Container(
                                    height: 118,
                                    width: 118,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFDDF8D1),
                                          Color(0xFF75F54A),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: darkGreen.withValues(
                                            alpha: 0.13,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'AM',
                                      style: TextStyle(
                                        color: darkGreen,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lime.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.workspace_premium_rounded,
                                          color: darkGreen,
                                          size: 17,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Premium Member',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: darkGreen,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF666B65),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // My Orders heading
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          8,
                          horizontalPadding,
                          17,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'My Orders',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),

                      // Order shortcuts
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          childAspectRatio: width > 600 ? 1.5 : 1.0,
                          children: [
                            _orderCard(
                              icon: Icons.account_balance_wallet_rounded,
                              title: 'To Pay',
                              color: const Color(0xFF149FE0),
                            ),
                            _orderCard(
                              icon: Icons.local_shipping_rounded,
                              title: 'Delivered',
                              color: const Color(0xFFE6B21A),
                            ),
                            _orderCard(
                              icon: Icons.inventory_2_rounded,
                              title: 'Processing',
                              color: const Color(0xFFE94E91),
                            ),
                            _orderCard(
                              icon: Icons.cancel_rounded,
                              title: 'Cancelled',
                              color: const Color(0xFF25C65B),
                            ),
                            _orderCard(
                              icon: Icons.favorite_rounded,
                              title: 'Wishlist',
                              color: const Color(0xFFEC4A78),
                            ),
                            _orderCard(
                              icon: Icons.headset_mic_rounded,
                              title: 'Customer Care',
                              color: const Color(0xFF8A72E8),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Account options
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFEDF0EA),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.025),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _menuItem(
                              icon: Icons.location_on_outlined,
                              title: 'Shipping Address',
                              onTap: () => _openFeature(
                                'Shipping Address',
                                Icons.location_on_outlined,
                              ),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.credit_card_outlined,
                              title: 'Payment Methods',
                              onTap: () => _openFeature(
                                'Payment Methods',
                                Icons.credit_card_outlined,
                              ),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.headset_mic_outlined,
                              title: 'Help & Support',
                              onTap: () => _openFeature(
                                'Help & Support',
                                Icons.headset_mic_outlined,
                              ),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.notifications_none_rounded,
                              title: 'Notifications',
                              onTap: () {
                                setState(() {
                                  notificationsEnabled =
                                  !notificationsEnabled;
                                });
                                _showMessage(
                                  notificationsEnabled
                                      ? 'Notifications enabled'
                                      : 'Notifications disabled',
                                );
                              },
                              trailing: Switch.adaptive(
                                value: notificationsEnabled,
                                activeTrackColor: lime,
                                onChanged: (value) {
                                  setState(() {
                                    notificationsEnabled = value;
                                  });
                                },
                              ),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.language_rounded,
                              title: 'Language',
                              onTap: () => _openFeature(
                                'Language',
                                Icons.language_rounded,
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'English',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: darkGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                    color: Color(0xFF858B88),
                                  ),
                                ],
                              ),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.info_outline_rounded,
                              title: 'About App',
                              onTap: () => _openFeature(
                                'About App',
                                Icons.info_outline_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logout button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 59,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(
                              Icons.logout_rounded,
                              size: 23,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEF4444),
                              side: const BorderSide(
                                color: Color(0xFFFF7777),
                                width: 1.4,
                              ),
                              backgroundColor: const Color(0xFFFFF8F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Profile header curved background
class ProfileHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFE9FBDD),
          Color(0xFFDDF8D1),
          Color(0xFFF8F9F7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.67)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.05,
        0,
        size.height * 0.67,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ProfileHeaderPainter oldDelegate) => false;
}
