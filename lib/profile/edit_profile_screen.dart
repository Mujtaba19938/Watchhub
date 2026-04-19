import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameCtrl = TextEditingController(text: "James Bond");
  final emailCtrl = TextEditingController(text: "james.bond@mi6.gov.uk");
  final phoneCtrl = TextEditingController(text: "+44 20 7930 4832");

  @override
  Widget build(BuildContext context) {
    const fieldColor = Color(0xFF1A2333);
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER BAR
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // AVATAR WITH EDIT BUTTON
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(
                          "assets/images/profile_avatar.png",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // FULL NAME
                const Text(
                  "Full Name",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                _inputField(controller: nameCtrl),

                const SizedBox(height: 20),

                // EMAIL
                const Text(
                  "Email Address",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                _inputField(controller: emailCtrl),

                const SizedBox(height: 20),

                // PHONE
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                _inputField(controller: phoneCtrl),

                const SizedBox(height: 35),

                // SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint("Saving profile…");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  // INPUT FIELD WIDGET
  Widget _inputField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1A2333),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}
