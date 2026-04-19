import 'package:flutter/material.dart';
import 'package:watchhub_onboarding/widgets/app_gradient_bg.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ---------------------------------------------------------
  // DYNAMIC PRODUCT LIST (You can fetch this from API later)
  // ---------------------------------------------------------
  List<Map<String, dynamic>> products = [
    {
      "image": "assets/images/d391cff738-c8c60391941da902440a.png",
      "name": "Rolex Submariner",
      "sku": "RLX-SUB-001",
      "price": 14500,
      "qty": 24,
    },
    {
      "image": "assets/images/2bb5acb5cc-f95da6ec11dc10051b5a.png",
      "name": "Omega Speedmaster",
      "sku": "OMG-SPD-007",
      "price": 7800,
      "qty": 3,
    },
    {
      "image": "assets/images/bd30e9bcc4-da300b14e6bac8ee9434.png",
      "name": "TAG Heuer Carrera",
      "sku": "TAG-CAR-003",
      "price": 6200,
      "qty": 0,
    }
  ];

  // -----------------------------
  // SEARCH LOGIC
  // -----------------------------
  List<Map<String, dynamic>> get filteredProducts {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return products;

    return products.where((p) {
      return p["name"].toLowerCase().contains(query) ||
          p["sku"].toLowerCase().contains(query);
    }).toList();
  }

  // -----------------------------
  // STATUS COLOR + LABEL LOGIC
  // -----------------------------
  Widget _buildStockBadge(int qty) {
    String label;
    Color color;

    if (qty == 0) {
      label = "Out of Stock";
      color = Colors.redAccent.shade200;
    } else if (qty < 5) {
      label = "Low Stock";
      color = Colors.orangeAccent;
    } else {
      label = "In Stock";
      color = Colors.greenAccent.shade400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1A2333);
    const searchColor = Color(0xFF1C2533);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------
            // HEADER
            // ---------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Products",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Icon(Icons.add, color: Colors.amber, size: 26),
                ],
              ),
            ),

            // ---------------------------------------
            // SEARCH BAR
            // ---------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: searchColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white54),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search products...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------
            // PRODUCT LIST
            // ---------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredProducts.length,
                itemBuilder: (_, index) {
                  final product = filteredProducts[index];

                  return GestureDetector(
                    onTap: () {
                      debugPrint("Open edit: ${product["name"]}");
                      // TODO: navigate to edit page
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              product["image"],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 14),

                          // TITLE + SKU + PRICE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product["name"],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 6),
                                          Text("SKU: ${product["sku"]}",
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12)),
                                          const SizedBox(height: 4),
                                          Text(
                                            "\$${product["price"].toStringAsFixed(0)}",
                                            style: const TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildStockBadge(product["qty"]),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Qty: ${product["qty"]}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // QTY ON RIGHT
                          const SizedBox.shrink()
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
