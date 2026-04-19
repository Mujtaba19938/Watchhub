import 'package:flutter/material.dart';
import 'package:watchhub_onboarding/widgets/app_gradient_bg.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final List<Map<String, dynamic>> orders = [
    {
      "orderId": "WH-84321",
      "name": "Eleanor Vance",
      "date": "2025-11-18",
      "total": 14500.0,
      "status": "Processing",
    },
    {
      "orderId": "WH-84320",
      "name": "Marcus Thorne",
      "date": "2025-11-17",
      "total": 7800.0,
      "status": "Shipped",
    },
    {
      "orderId": "WH-84319",
      "name": "Julian Hayes",
      "date": "2025-11-16",
      "total": 6200.0,
      "status": "Cancelled",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xff111a2d);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Orders",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Monitor live fulfillment status",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff0f1729),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list,
                            color: Colors.white70),
                        onPressed: () {
                          debugPrint("Filter action tapped");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final order = orders[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order #${order["orderId"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _statusBadge(order["status"]),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Customer: ${order["name"]}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${_formatDate(order["date"])}",
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatCurrency(order["total"]),
                                style: const TextStyle(
                                  color: Color(0xfff7c049),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  debugPrint(
                                      "View order ${order["orderId"]} details");
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.amberAccent,
                                ),
                                icon: const Text(
                                  "View Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                label: const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                ),
                              ),
                            ],
                          )
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

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case "Shipped":
        color = Colors.greenAccent.shade400;
        break;
      case "Cancelled":
        color = Colors.redAccent.shade200;
        break;
      default:
        color = const Color(0xff4a86ff);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatCurrency(num value) {
    return "\$${value.toStringAsFixed(2)}";
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      final month = months[date.month - 1];
      return "$month ${date.day}, ${date.year}";
    } catch (_) {
      return rawDate;
    }
  }
}
