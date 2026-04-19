import 'package:flutter/material.dart';
import '../widgets/app_gradient_bg.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _wishlistService = WishlistService();
  final _cartService = CartService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isInWishlist = _wishlistService.isInWishlist(widget.product);
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------------
                      // TOP PRODUCT IMAGE
                      // ------------------------
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(26),
                              bottomRight: Radius.circular(26),
                            ),
                            child: Image.asset(
                              widget.product["image"],
                              height: 340,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Back + Wishlist Icons
                          Positioned(
                            top: 10,
                            left: 10,
                            child: _circleBtn(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _circleBtn(
                              icon: isInWishlist
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              iconColor: isInWishlist ? Colors.red : Colors.white,
                              onTap: () {
                                final wasAdded = _wishlistService.toggleWishlist(widget.product);
                                setState(() {}); // Refresh UI
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      wasAdded
                                          ? "Added to wishlist"
                                          : "Removed from wishlist",
                                    ),
                                    backgroundColor: wasAdded ? Colors.green : Colors.orange,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Page indicator dots
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _dot(true),
                                _dot(false),
                                _dot(false),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ------------------------
                      // PRODUCT DETAILS
                      // ------------------------
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product["brand"].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 13,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              widget.product["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Text(
                                  "\$${widget.product["price"].toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _stockBadge(widget.product["qty"]),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ------------------------
                            // Rating Row
                            // ------------------------
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2533),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.product["rating"].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 4),

                                  const Text(
                                    "(128 Reviews)",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13),
                                  ),

                                  const Spacer(),

                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      color: Colors.white60, size: 16)
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // ------------------------
                            // SPECS
                            // ------------------------
                            const Text(
                              "Specifications",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),

                            _spec("Reference", widget.product["reference"]),
                            _spec("Case Size", widget.product["case"]),
                            _spec("Material", widget.product["material"]),
                            _spec("Movement", widget.product["movement"]),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------
              // BOTTOM BUTTON
              // ------------------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 80,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _cartService.addToCart(widget.product);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to cart successfully"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      "Add to Bag",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------
  // SMALL HELPERS
  // ------------------------
  Widget _circleBtn({
    required IconData icon,
    required Function() onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.45),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: active ? 9 : 7,
      width: active ? 9 : 7,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white38,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _stockBadge(int qty) {
    Color color;
    String text;

    if (qty == 0) {
      color = Colors.redAccent.shade200;
      text = "Out of Stock";
    } else if (qty < 5) {
      color = Colors.orangeAccent;
      text = "Low Stock";
    } else {
      color = Colors.greenAccent.shade400;
      text = "In Stock";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _spec(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
