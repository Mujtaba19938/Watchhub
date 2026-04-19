import 'package:flutter/material.dart';
import 'package:watchhub_onboarding/widgets/app_gradient_bg.dart';
import '../services/user_management_service.dart';
import '../services/user_service.dart';
import '../auth/login_screen.dart';

class AdminUserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminUserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final _userManagementService = UserManagementService();
    final _userService = UserService();
    final isBanned = _userManagementService.isUserBanned(user['email']);
    final isCurrentlyLoggedIn = _userService.isLoggedIn &&
        _userService.getEmail() == user['email'];

    const cardColor = Color(0xFF1A2333);
    const gold = Color(0xFFE0B43A);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
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
                      "User Details",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Profile Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: isBanned
                            ? Colors.redAccent.withOpacity(0.3)
                            : gold.withOpacity(0.3),
                        child: user['profileImageUrl'] != null &&
                                (user['profileImageUrl'] as String).isNotEmpty
                            ? CircleAvatar(
                                radius: 48,
                                backgroundImage:
                                    NetworkImage(user['profileImageUrl']),
                              )
                            : Text(
                                (user['name'] as String? ?? 'U')[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Banned Badge
                      if (isBanned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.redAccent, width: 1),
                          ),
                          child: const Text(
                            "BANNED",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // User Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Name", user['name'] ?? 'N/A'),
                            const SizedBox(height: 16),
                            _buildInfoRow("Email", user['email'] ?? 'N/A'),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              "Registered",
                              user['registeredAt'] != null
                                  ? _formatDate(user['registeredAt'])
                                  : 'N/A',
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              "Status",
                              isBanned ? "Banned" : "Active",
                              valueColor: isBanned
                                  ? Colors.redAccent
                                  : Colors.greenAccent,
                            ),
                            if (isCurrentlyLoggedIn) ...[
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                "Current Status",
                                "Currently Logged In",
                                valueColor: Colors.orangeAccent,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Ban/Unban Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBanned ? Colors.green : Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _showBanDialog(
                              context,
                              user['email'],
                              isBanned,
                              isCurrentlyLoggedIn,
                            );
                          },
                          child: Text(
                            isBanned ? "Unban User" : "Ban This User",
                            style: const TextStyle(
                              color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return isoString;
    }
  }

  void _showBanDialog(
    BuildContext context,
    String email,
    bool isBanned,
    bool isCurrentlyLoggedIn,
  ) {
    final _userManagementService = UserManagementService();
    final _userService = UserService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2333),
        title: Text(
          isBanned ? "Unban User?" : "Ban User?",
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          isBanned
              ? "Are you sure you want to unban this user? They will be able to log in again."
              : "Are you sure you want to ban this user? They will be logged out immediately and won't be able to log in again.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? Colors.green : Colors.redAccent,
            ),
            onPressed: () async {
              if (isBanned) {
                await _userManagementService.unbanUser(email);
              } else {
                await _userManagementService.banUser(email);

                // If the banned user is currently logged in, log them out
                if (isCurrentlyLoggedIn) {
                  await _userService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              }

              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to users list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBanned
                        ? "User has been unbanned"
                        : "User has been banned and logged out",
                  ),
                  backgroundColor: isBanned ? Colors.green : Colors.redAccent,
                ),
              );
            },
            child: Text(
              isBanned ? "Unban" : "Ban",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

