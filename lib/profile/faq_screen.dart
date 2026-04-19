import 'package:flutter/material.dart';
import '../widgets/app_gradient_bg.dart';
import 'chat_screen.dart';
import 'faq_detail_screen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _faqs = [
    {
      "question": "How do I track my order?",
      "answer":
          "Once your order is confirmed, you'll receive a tracking number via email. You can use this number to track your shipment in real-time through our tracking portal or the carrier's website.",
    },
    {
      "question": "What is your return policy?",
      "answer":
          "We offer a 30-day return policy for unworn watches in their original condition with all packaging and documentation. Custom or engraved items are not eligible for return. Please contact our support team to initiate a return.",
    },
    {
      "question": "Are all watches authentic?",
      "answer":
          "Yes, absolutely. At WatchHub, authenticity is the cornerstone of our business. We guarantee that every timepiece we sell is 100% authentic and comes with its original manufacturer's warranty and documentation. Our team of certified watchmakers meticulously inspects each watch for authenticity and condition before it is listed on our platform.",
    },
    {
      "question": "Do you offer international shipping?",
      "answer":
          "Yes, we ship worldwide. Shipping costs and delivery times vary by location. International orders may be subject to customs duties and taxes, which are the responsibility of the recipient. We recommend checking your local customs regulations before placing an order.",
    },
    {
      "question": "What payment methods are accepted?",
      "answer":
          "We accept all major credit cards (Visa, Mastercard, American Express), PayPal, bank transfers, and cryptocurrency. For high-value purchases, we also offer financing options through our partner providers.",
    },
    {
      "question": "How does the warranty work?",
      "answer":
          "All new watches come with the manufacturer's original warranty, typically ranging from 2 to 5 years depending on the brand. Pre-owned watches are covered by our 1-year WatchHub warranty. Warranty covers manufacturing defects and movement issues, but not damage from accidents or normal wear.",
    },
  ];

  List<Map<String, dynamic>> get filteredFAQs {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _faqs;

    return _faqs
        .where((faq) =>
            faq["question"].toLowerCase().contains(query) ||
            faq["answer"].toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1A2333);
    const searchColor = Color(0xFF1C2533);
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      "Frequently Asked Questions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: searchColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                            hintText: "Search questions...",
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

              // FAQ List
              Expanded(
                child: filteredFAQs.isEmpty
                    ? Center(
                        child: Text(
                          "No questions found",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredFAQs.length,
                        itemBuilder: (context, index) {
                          final faq = filteredFAQs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FAQDetailScreen(faq: faq),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      faq["question"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.white38, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Chat With Us Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChatScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, color: gold),
                        const SizedBox(width: 12),
                        Text(
                          "Chat With Us",
                          style: TextStyle(
                            color: gold,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

