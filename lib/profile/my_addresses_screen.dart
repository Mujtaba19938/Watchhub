import 'package:flutter/material.dart';

class MyAddressesScreen extends StatelessWidget {
  MyAddressesScreen({super.key});

  final List<Map<String, dynamic>> addresses = [
    {
      "title": "Home",
      "name": "James Bond",
      "phone": "+44 20 7930 4832",
      "address":
          "221B Baker Street\nLondon, NW1 6XE\nUnited Kingdom",
    },
    {
      "title": "Office",
      "name": "James Bond",
      "phone": "+44 20 7000 1111",
      "address":
          "MI6 Headquarters\nThames House, Millbank\nLondon, SW1P 4QE",
    },
  ];

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const cardColor = Color(0xFF0F1729);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: gold,
        onPressed: () {
          // TODO: navigate to Add Address screen
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
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
              _header(context),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: addresses.length,
                  itemBuilder: (_, i) {
                    final item = addresses[i];
                    return AddressCard(
                      title: item["title"],
                      name: item["name"],
                      phone: item["phone"],
                      address: item["address"],
                      onEdit: () {},
                      onDelete: () {},
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

  // HEADER
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            "My Addresses",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------
// ADDRESS CARD WIDGET
// -----------------------------------------------------------
class AddressCard extends StatelessWidget {
  final String title;
  final String name;
  final String phone;
  final String address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF0F1729);
    const gold = Color(0xFFE0B43A);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE + ACTIONS
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: onDelete,
                child:
                    const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            phone,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            address,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
