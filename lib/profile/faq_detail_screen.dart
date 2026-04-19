import 'package:flutter/material.dart';
import '../widgets/app_gradient_bg.dart';

class FAQDetailScreen extends StatefulWidget {
  final Map<String, dynamic> faq;

  const FAQDetailScreen({super.key, required this.faq});

  @override
  State<FAQDetailScreen> createState() => _FAQDetailScreenState();
}

class _FAQDetailScreenState extends State<FAQDetailScreen> {
  bool? _wasHelpful;

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1A2333);

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
                      "FAQ Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        widget.faq["question"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Answer
                      Text(
                        widget.faq["answer"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Feedback Section
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Was this helpful?",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _FeedbackButton(
                                  icon: Icons.thumb_up_outlined,
                                  label: "Yes",
                                  isSelected: _wasHelpful == true,
                                  onTap: () {
                                    setState(() {
                                      _wasHelpful = true;
                                    });
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                                const SizedBox(width: 16),
                                _FeedbackButton(
                                  icon: Icons.thumb_down_outlined,
                                  label: "No",
                                  isSelected: _wasHelpful == false,
                                  onTap: () {
                                    setState(() {
                                      _wasHelpful = false;
                                    });
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
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

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE0B43A).withOpacity(0.2)
              : const Color(0xFF1A2333),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFFE0B43A), width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE0B43A) : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFE0B43A) : Colors.white70,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

