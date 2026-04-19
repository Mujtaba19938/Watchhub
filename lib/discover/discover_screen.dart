import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_gradient_bg.dart';
import '../widgets/floating_nav_bar.dart';
import '../cart/cart_screen.dart';
import '../wishlist/wishlist_screen.dart';

class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({super.key});

  final List<Map<String, dynamic>> trending = [
    {
      "image": "assets/images/watch1.png",
      "name": "Rolex Submariner",
      "price": 14500,
    },
    {
      "image": "assets/images/watch2.png",
      "name": "Omega Speedmaster",
      "price": 7800,
    },
    {
      "image": "assets/images/watch3.png",
      "name": "TAG Heuer Carrera",
      "price": 6200,
    },
  ];

  final List<Map<String, dynamic>> collections = [
    {
      "image": "assets/images/banner1.png",
      "title": "Dive Watch Collection",
      "subtitle": "Crafted for the deep sea"
    },
    {
      "image": "assets/images/banner2.png",
      "title": "Chronograph Series",
      "subtitle": "Precision and performance"
    },
  ];

  final List<String> brands = [
    "assets/images/brand_rolex.png",
    "assets/images/brand_omega.png",
    "assets/images/brand_tag.png",
    "assets/images/brand_pp.png",
  ];

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AppGradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -----------------------------------------
                // HERO BANNER
                // -----------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/hero_watch.png",
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Discover Luxury",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Curated timepieces for every collector.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // -----------------------------------------
                // TRENDING
                // -----------------------------------------
                _sectionTitle("Trending Timepieces"),
                const SizedBox(height: 10),

                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    itemCount: trending.length,
                    itemBuilder: (context, i) {
                      final item = trending[i];
                      return _trendingCard(item);
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // -----------------------------------------
                // FEATURED COLLECTIONS
                // -----------------------------------------
                _sectionTitle("Featured Collections"),

                const SizedBox(height: 12),

                Column(
                  children: [
                    for (var col in collections)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: _collectionCard(col),
                      ),
                  ],
                ),

                const SizedBox(height: 30),

                // -----------------------------------------
                // BRANDS ROW
                // -----------------------------------------
                _sectionTitle("Brands You May Like"),
                const SizedBox(height: 12),

                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    itemCount: brands.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2533),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Image.asset(brands[i], height: 40),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // -----------------------------------------
                // NEW ARRIVALS
                // -----------------------------------------
                _sectionTitle("New Arrivals"),
                const SizedBox(height: 10),

                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    itemCount: trending.length,
                    itemBuilder: (context, i) {
                      final item = trending[i];
                      return _trendingCard(item);
                    },
                  ),
                ),
              ],
            ),
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
              selectedIndex: 1,
              onItemTapped: (index) {
                if (index == 1) return;
                HapticFeedback.lightImpact();
                if (index == 0) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  return;
                }
                if (index == 2) {
                  Navigator.of(context).pushReplacement(navRoute(const WishlistScreen()));
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

  // -----------------------------------------
  // SECTION TITLE
  // -----------------------------------------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // -----------------------------------------
  // TRENDING WATCH CARD
  // -----------------------------------------
  Widget _trendingCard(Map<String, dynamic> item) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              item["image"],
              height: 120,
              width: 160,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${item["price"]}",
                  style: const TextStyle(
                    color: Color(0xFFE0B43A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // -----------------------------------------
  // COLLECTION CARD (Large Banner Style)
  // -----------------------------------------
  Widget _collectionCard(Map<String, dynamic> col) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.asset(
            col["image"],
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  col["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  col["subtitle"],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
