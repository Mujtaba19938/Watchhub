import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import '../widgets/app_gradient_bg.dart';
import 'my_addresses_screen.dart';
import 'order_history_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'faq_screen.dart';
import '../services/user_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF0F1729);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Back button row
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TITLE
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 22),

                // AVATAR
                _buildProfileAvatar(),

                const SizedBox(height: 16),

                // NAME
                Text(
                  _userService.isLoggedIn
                      ? _userService.getDisplayName()
                      : "Guest",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // EMAIL
                Text(
                  _userService.isLoggedIn && _userService.getEmail().isNotEmpty
                      ? _userService.getEmail()
                      : "Not logged in",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // MAIN CARD (MENU ITEMS)
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.edit_outlined,
                        label: "Edit Profile",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.map_outlined,
                        label: "My Addresses",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MyAddressesScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.favorite_border,
                        label: "Wishlist",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WishlistScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.shopping_bag_outlined,
                        label: "Order History",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        label: "Settings",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FAQScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // LOGOUT ROW
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: InkWell(
                    onTap: () async {
                      await _userService.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent, size: 20),
                        SizedBox(width: 12),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // separator line inside the card
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  // Build profile avatar
  Widget _buildProfileAvatar() {
    try {
      if (!_userService.isLoggedIn) {
        // Default avatar for guest
        return const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/images/img3.png"),
        );
      }

      final profileImageUrl = _userService.getProfileImageUrl();
      final initial = _userService.getInitial();

      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        // If user has a profile image URL, show it
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profileImageUrl),
          onBackgroundImageError: (_, __) {
            // Fallback to initial if image fails to load
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE0B43A),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        // If logged in but no image, show initial
        return CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFFE0B43A),
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } catch (e) {
      // Fallback to default avatar on error
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage("assets/images/img3.png"),
      );
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

