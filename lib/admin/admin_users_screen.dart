import 'package:flutter/material.dart';
import 'package:watchhub_onboarding/widgets/app_gradient_bg.dart';
import '../services/user_management_service.dart';
import 'admin_user_detail_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _userManagementService = UserManagementService();

  @override
  void initState() {
    super.initState();
    // Ensure UserManagementService is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userManagementService.initialize().then((_) {
        if (mounted) {
          setState(() {}); // Refresh the UI
        }
      });
    });
  }

  // Get all users from management service
  List<Map<String, dynamic>> get users {
    return _userManagementService.getAllUsers();
  }

  // Filtered results based on search
  List<Map<String, dynamic>> get filteredUsers {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return users;

    return users.where((u) {
      return (u["name"] as String? ?? '').toLowerCase().contains(query) ||
          (u["email"] as String? ?? '').toLowerCase().contains(query);
    }).toList();
  }

  // Build avatar widget
  Widget _buildAvatar(Map<String, dynamic> user) {
    final isBanned = _userManagementService.isUserBanned(user['email']);
    final name = user['name'] as String? ?? 'U';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    if (user['profileImageUrl'] != null &&
        (user['profileImageUrl'] as String).isNotEmpty) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: isBanned
            ? Colors.redAccent.withOpacity(0.3)
            : Colors.transparent,
        backgroundImage: NetworkImage(user['profileImageUrl']),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: isBanned
          ? Colors.redAccent.withOpacity(0.3)
          : const Color(0xFFE0B43A).withOpacity(0.3),
      child: Text(
        initial,
        style: TextStyle(
          color: isBanned ? Colors.redAccent : const Color(0xFFE0B43A),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const searchColor = Color(0xff1C2533);
    const cardColor = Color(0xff1A2333);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------
            // HEADER
            // -------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Users",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.person_add_alt_1, color: Colors.amber, size: 26),
                ],
              ),
            ),

            // -------------------------------
            // SEARCH BAR
            // -------------------------------
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
                          hintText: "Search users by name or email...",
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

            // -------------------------------
            // USER LIST
            // -------------------------------
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        users.isEmpty
                            ? "No users registered yet"
                            : "No users found",
                        style: const TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredUsers.length,
                      itemBuilder: (_, index) {
                  final user = filteredUsers[index];

                  final isBanned = _userManagementService.isUserBanned(user['email']);

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AdminUserDetailScreen(user: user),
                        ),
                      ).then((_) {
                        // Refresh the list when returning from detail screen
                        setState(() {});
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: isBanned
                            ? Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          _buildAvatar(user),

                          const SizedBox(width: 14),

                          // NAME + EMAIL
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user["name"] ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (isBanned)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          "BANNED",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user["email"] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white38, size: 18)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
