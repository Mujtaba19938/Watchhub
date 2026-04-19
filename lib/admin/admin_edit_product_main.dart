import 'package:flutter/material.dart';

import 'admin_edit_product_screen.dart';

void main() {
  runApp(const AdminEditProductDemoApp());
}

class AdminEditProductDemoApp extends StatelessWidget {
  const AdminEditProductDemoApp({super.key});

  static const Map<String, dynamic> _demoProduct = {
    "name": "Aurora Chrono",
    "brand": "LuxeTime",
    "price": 1299,
    "qty": 12,
    "description":
        "Premium chronograph with sapphire crystal and Swiss automatic movement.",
    "image": "assets/images/img1.png",
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminEditProductScreen(product: _demoProduct),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE0B43A)),
        useMaterial3: false,
      ),
    );
  }
}

