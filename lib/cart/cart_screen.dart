import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_gradient_bg.dart';
import '../widgets/floating_nav_bar.dart';
import '../services/cart_service.dart';
import '../discover/discover_screen.dart';
import '../wishlist/wishlist_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartService = CartService();

  final List<Map<String, dynamic>> _navItems = const [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.search, "label": "Discover"},
    {"icon": Icons.favorite_border, "label": "Wishlist"},
    {"icon": Icons.shopping_cart_outlined, "label": "Cart"},
  ];

  int _selectedIndex = 3;

  List<Map<String, dynamic>> get cartItems => _cartService.cartItems;
  double get subtotal => _cartService.subtotal;
  double get shipping => _cartService.shipping;
  double get total => _cartService.total;

  @override
  void initState() {
    super.initState();
    // Add some default items if cart is empty (for demo purposes)
    if (_cartService.cartItems.isEmpty) {
      _cartService.addToCart({
        "image": "assets/images/e32d27bcae-631fc6ddb02fe5b97199.png",
        "brand": "Rolex",
        "name": "Cosmograph Daytona",
        "price": 28500.0,
      });
      _cartService.addToCart({
        "image": "assets/images/a20300d8e0-e7b4be10de44aaaceb2c.png",
        "brand": "Omega",
        "name": "Seamaster Diver 300M",
        "price": 5400.0,
      });
    }
  }

  // Refresh cart when screen is opened
  void _refreshCart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const cardColor = Color(0xFF1A2333);
    const chipColor = Color(0xFF1C2533);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AppGradientBackground(
            child: SafeArea(
              child: Column(
                children: [
              // -----------------------------
              // HEADER
              // -----------------------------
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Your Bag",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 26),
                  ],
                ),
              ),

              // -----------------------------
              // CART LIST
              // -----------------------------
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          "Your bag is empty.",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    item["image"],
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // TEXT + QTY
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["brand"],
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 12,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "\$${(item["price"] as double).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // QTY CONTROL + REMOVE
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: chipColor,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              children: [
                                                _qtyBtn(
                                                  icon: Icons.remove,
                                                  onTap: () {
                                                    setState(() {
                                                      if (item["qty"] > 1) {
                                                        _cartService.updateQuantity(index, item["qty"] - 1);
                                                      } else {
                                                        _cartService.removeFromCart(index);
                                                      }
                                                    });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                  ),
                                                  child: Text(
                                                    item["qty"].toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                _qtyBtn(
                                                  icon: Icons.add,
                                                  onTap: () {
                                                    setState(() {
                                                      _cartService.updateQuantity(index, item["qty"] + 1);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _cartService.removeFromCart(index);
                                              });
                                            },
                                            child: const Text(
                                              "Remove",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // -----------------------------
              // SUMMARY + CHECKOUT
              // -----------------------------
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF050811).withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _summaryRow("Subtotal", subtotal),
                    const SizedBox(height: 6),
                    _summaryRow("Shipping", shipping),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 10),
                    _summaryRow("Total", total, bold: true),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: cartItems.isEmpty
                            ? null
                            : () {
                                // TODO: go to checkout
                                debugPrint("Proceed to checkout: $total");
                              },
                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Space so the summary section clears the floating nav bar
              const SizedBox(height: 88),
            ],
          ),
        ),
      ),
          // Floating glassmorphism nav bar
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                final label = _navItems[index]["label"] as String;
                if (label == "Cart") return;
                HapticFeedback.lightImpact();
                if (label == "Home") {
                  Navigator.of(context).pop();
                  return;
                }
                if (label == "Discover") {
                  Navigator.of(context).pushReplacement(navRoute(DiscoverScreen()));
                  return;
                }
                if (label == "Wishlist") {
                  Navigator.of(context).pushReplacement(navRoute(const WishlistScreen()));
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // HELPERS
  // -----------------------------
  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF111827),
        ),
        child: Icon(icon, size: 14, color: Colors.white70),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

