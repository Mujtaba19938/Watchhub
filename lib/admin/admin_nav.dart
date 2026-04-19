import 'package:flutter/material.dart';
import 'admin_products_screen.dart';
import 'admin_users_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_profile_screen.dart';

class AdminNav extends StatefulWidget {
  final int initialIndex;

  const AdminNav({super.key, this.initialIndex = 0});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  late int _index;
  late final List<_AdminDestination> _destinations;

  @override
  void initState() {
    super.initState();
    _destinations = const [
      _AdminDestination(
        icon: Icons.inventory_2_rounded,
        label: "Products",
        screen: AdminProductsScreen(),
      ),
      _AdminDestination(
        icon: Icons.people_alt_rounded,
        label: "Users",
        screen: AdminUsersScreen(),
      ),
      _AdminDestination(
        icon: Icons.receipt_long_rounded,
        label: "Orders",
        screen: AdminOrdersScreen(),
      ),
      _AdminDestination(
        icon: Icons.person_outline_rounded,
        label: "Profile",
        screen: const AdminProfileScreen(),
      ),
    ];

    _index = widget.initialIndex;
    if (_index < 0 || _index >= _destinations.length) {
      _index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Colors.transparent;

    return Scaffold(
      backgroundColor: bg,
      body: IndexedStack(
        index: _index,
        children: _destinations.map((dest) => dest.screen).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0E1525),
              Color(0xFF0A0F1A),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: List.generate(_destinations.length, (idx) {
            final dest = _destinations[idx];
            return Expanded(
              child: _navItem(dest.icon, dest.label, idx),
            );
          }),
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // REUSABLE NAV ITEM
  // --------------------------------------------------------------
  Widget _navItem(IconData icon, String label, int idx) {
    final bool active = _index == idx;
    return GestureDetector(
      onTap: () => setState(() => _index = idx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 24, color: active ? Colors.amber : Colors.white54),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.amber : Colors.white54,
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminDestination {
  final IconData icon;
  final String label;
  final Widget screen;

  const _AdminDestination({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
