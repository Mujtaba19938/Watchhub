import 'package:flutter/material.dart';

import 'admin_nav.dart';

void main() {
  runApp(const OrdersApp());
}

class OrdersApp extends StatelessWidget {
  const OrdersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminNav(initialIndex: 2),
    );
  }
}
