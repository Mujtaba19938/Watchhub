import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watchhub_onboarding/widgets/app_gradient_bg.dart';

class AdminEditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const AdminEditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product["name"]);
    brandController = TextEditingController(text: widget.product["brand"]);
    priceController =
        TextEditingController(text: widget.product["price"].toString());
    stockController =
        TextEditingController(text: widget.product["qty"].toString());
    descriptionController =
        TextEditingController(text: widget.product["description"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Edit Product",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildPreviewImage(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _selectedImageFile == null
                                ? "Tap to change image"
                                : "Tap to pick a different image",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _label("Product Name"),
                _inputField(nameController),
                const SizedBox(height: 18),
                _label("Brand"),
                _inputField(brandController),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Price"),
                          _inputField(priceController,
                              keyboard: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Stock Qty"),
                          _inputField(stockController,
                              keyboard: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _label("Description"),
                _inputField(
                  descriptionController,
                  maxLines: 5,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      debugPrint("Updated product: ${nameController.text}");
                    },
                    child: const Text(
                      "Update Product",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (file == null) return;
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
      } else {
        setState(() {
          _selectedImageFile = File(file.path);
          _selectedImageBytes = null;
        });
      }
    } catch (e) {
      debugPrint("Failed to pick image: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open gallery. Please try again."),
        ),
      );
    }
  }

  Widget _buildPreviewImage() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 90,
        width: 90,
        fit: BoxFit.cover,
      );
    }
    if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        height: 90,
        width: 90,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      widget.product["image"],
      height: 90,
      width: 90,
      fit: BoxFit.cover,
    );
  }

  // -------------------------------
  // REUSABLE LABEL
  // -------------------------------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // -------------------------------
  // REUSABLE INPUT FIELD
  // -------------------------------
  Widget _inputField(
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2533),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
