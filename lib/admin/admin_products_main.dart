import 'package:flutter/material.dart';

import 'admin_nav.dart';

void main() {
  runApp(const AdminProductsApp());
}

class AdminProductsApp extends StatelessWidget {
  const AdminProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminNav(initialIndex: 0),
    );
  }
}
