import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Order Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ORDER ID + STATUS
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Order #WH654321",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Placed on Nov 18, 2025",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "In Transit",
                        style: TextStyle(
                          color: Color(0xFF4CA6FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// ORDER TRACKING TITLE
                const Text(
                  "Order Tracking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// TRACKING STEPS
                _trackingStep(
                  completed: true,
                  title: "Out for Delivery",
                  timestamp: "Nov 19, 2025, 09:15 AM",
                  location: "",
                ),
                _trackingStep(
                  completed: true,
                  title: "Package arrived at facility",
                  timestamp: "Nov 19, 2025, 03:30 AM",
                  location: "London, UK",
                ),
                _trackingStep(
                  completed: true,
                  title: "Package Shipped",
                  timestamp: "Nov 18, 2025, 08:00 PM",
                  location: "Geneva, CH",
                ),
                _trackingStep(
                  completed: true,
                  title: "Order Confirmed",
                  timestamp: "Nov 18, 2025, 10:05 AM",
                  location: "",
                ),

                const SizedBox(height: 25),

                Divider(color: Colors.white24),

                const SizedBox(height: 20),

                /// ITEMS
                const Text(
                  "Items",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/watch1.png",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Rolex Submariner Date",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Qty: 1",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Text(
                      "\$10,100",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Divider(color: Colors.white24),

                const SizedBox(height: 20),

                /// PAYMENT SUMMARY
                const Text(
                  "Payment Summary",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                _summaryRow("Subtotal", "\$10,100.00"),
                _summaryRow("Shipping", "\$0.00"),
                _summaryRow("Taxes", "\$2,020.00"),

                const SizedBox(height: 10),
                Divider(color: Colors.white24),
                const SizedBox(height: 10),

                _summaryRow(
                  "Total",
                  "\$12,120.00",
                  isTotal: true,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ─────────────────────────────────────────────────────────────
  /// TRACKING STEP WIDGET
  /// ─────────────────────────────────────────────────────────────
  Widget _trackingStep({
    required bool completed,
    required String title,
    required String timestamp,
    required String location,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BULLET
        Column(
          children: [
            Icon(
              completed ? Icons.radio_button_checked : Icons.circle_outlined,
              color: completed ? Color(0xFFE0B43A) : Colors.white38,
              size: 14,
            ),
            Container(
              width: 2,
              height: 46,
              color: Colors.white24,
            )
          ],
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// PAYMENT SUMMARY LINE
  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.white : Colors.white70,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.amber : Colors.white70,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
