import 'package:flutter/material.dart';

import '../orders/order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final List<Map<String, dynamic>> orders = [
    {
      "orderId": "WH789123",
      "date": "Nov 10, 2025",
      "status": "Delivered",
      "statusColor": Color(0xFF3CB371),
      "image": "assets/images/watch2.png",
      "name": "Omega Seamaster 300",
      "price": 5200,
      "items": 1,
      "button": "View Details",
    },
    {
      "orderId": "WH654321",
      "date": "Nov 18, 2025",
      "status": "In Transit",
      "statusColor": Color(0xFF4DA6FF),
      "image": "assets/images/watch1.png",
      "name": "Rolex Submariner Date",
      "price": 10100,
      "items": 1,
      "button": "Track Order",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF0F1729);
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E1525),
              Color(0xFF0A0F1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Order History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // BODY
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    final item = orders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ORDER ID + STATUS
                          Row(
                            children: [
                              Text(
                                "Order #${item["orderId"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (item["statusColor"] as Color)
                                      .withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item["status"],
                                  style: TextStyle(
                                    color: item["statusColor"],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 6),

                          // DATE
                          Text(
                            "Placed on ${item["date"]}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // PRODUCT ROW
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  item["image"],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["name"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${item["items"]} item",
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                "\$${item["price"]}",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (item["button"] == "View Details") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const OrderDetailsScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${item["button"]} coming soon"),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: gold, width: 1.3),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                              child: Text(
                                item["button"],
                                style: const TextStyle(
                                  color: Color(0xFFE0B43A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
