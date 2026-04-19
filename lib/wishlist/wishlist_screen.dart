import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../widgets/floating_nav_bar.dart';
import '../cart/cart_screen.dart';
import '../discover/discover_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wishlistService = WishlistService();
  final _cartService = CartService();

  @override
  void initState() {
    super.initState();
  }

  // Refresh when the screen becomes visible again
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh the list when screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always get fresh data from the service
    final wishlist = _wishlistService.wishlistItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0E1525), Color(0xFF0A0F1A)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _header(context),
                  Expanded(
                    child: wishlist.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border_rounded,
                                    size: 64, color: Colors.white38),
                                SizedBox(height: 16),
                                Text("Your wishlist is empty",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                  "Add items by tapping the heart icon",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 100),
                            itemCount: wishlist.length,
                            itemBuilder: (_, i) {
                              final item = wishlist[i];
                              return WishlistCard(
                                brand: item["brand"],
                                name: item["name"],
                                price: (item["price"] is int
                                    ? (item["price"] as int).toDouble()
                                    : item["price"] as double),
                                image: item["image"],
                                onDelete: () {
                                  _wishlistService
                                      .removeFromWishlistByIndex(i);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Removed from wishlist"),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                onMoveToCart: () {
                                  _cartService.addToCart(item);
                                  _wishlistService
                                      .removeFromWishlistByIndex(i);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Moved to cart"),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              items: const [
                {"icon": Icons.home, "label": "Home"},
                {"icon": Icons.search, "label": "Discover"},
                {"icon": Icons.favorite_border, "label": "Wishlist"},
                {"icon": Icons.shopping_cart_outlined, "label": "Cart"},
              ],
              selectedIndex: 2,
              onItemTapped: (index) {
                if (index == 2) return;
                HapticFeedback.lightImpact();
                if (index == 0) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  return;
                }
                if (index == 1) {
                  Navigator.of(context).pushReplacement(navRoute(DiscoverScreen()));
                  return;
                }
                if (index == 3) {
                  Navigator.of(context).pushReplacement(navRoute(const CartScreen()));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // HEADER
  // -----------------------------------------------------------
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            "My Wishlist",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

}

// -----------------------------------------------------------
// WISHLIST CARD WIDGET
// -----------------------------------------------------------
class WishlistCard extends StatelessWidget {
  final String brand;
  final String name;
  final double price;
  final String image;
  final VoidCallback onMoveToCart;
  final VoidCallback onDelete;

  const WishlistCard({
    super.key,
    required this.brand,
    required this.name,
    required this.price,
    required this.image,
    required this.onMoveToCart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const cardColor = Color(0xFF0F1729);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // WATCH IMAGE
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TEXT DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // MOVE TO CART BUTTON
                SizedBox(
                  height: 35,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: onMoveToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Move to Cart",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // DELETE BUTTON
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

