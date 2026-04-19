import 'package:flutter/material.dart';
import '../widgets/app_gradient_bg.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // ---------------------------------------------------
  // DYNAMIC WISHLIST DATA
  // ---------------------------------------------------
  List<Map<String, dynamic>> wishlist = [
    {
      "image": "assets/images/watch1.png",
      "brand": "Rolex",
      "name": "Cosmograph Daytona",
      "price": 28500.0,
    },
    {
      "image": "assets/images/watch2.png",
      "brand": "Omega",
      "name": "Seamaster Diver 300M",
      "price": 5400.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const cardColor = Color(0xFF1A2333);
    const chipColor = Color(0xFF1C2533);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
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
                      "Wishlist",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.favorite_rounded,
                        color: Colors.amber, size: 26),
                  ],
                ),
              ),

              // -----------------------------
              // EMPTY STATE
              // -----------------------------
              if (wishlist.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "Your wishlist is empty.",
                      style:
                          TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ),
                )
              else
                // -----------------------------
                // WISHLIST LIST
                // -----------------------------
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemCount: wishlist.length,
                    itemBuilder: (_, i) {
                      final item = wishlist[i];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // PRODUCT IMAGE
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

                            // DETAILS
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
                                      letterSpacing: 1,
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
                                    "\$${item["price"].toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // MOVE TO CART BUTTON
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: gold,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        debugPrint(
                                            "Move to cart: ${item["name"]}");
                                      },
                                      child: const Text(
                                        "Add to Bag",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            // REMOVE BUTTON
                            GestureDetector(
                              onTap: () {
                                setState(() => wishlist.removeAt(i));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: chipColor,
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
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
