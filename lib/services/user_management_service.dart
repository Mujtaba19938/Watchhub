import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserManagementService {
  static final UserManagementService _instance = UserManagementService._internal();
  factory UserManagementService() => _instance;
  UserManagementService._internal();

  // Store all registered users
  List<Map<String, dynamic>> _allUsers = [];
  
  // Store banned user emails
  Set<String> _bannedUsers = {};
  
  bool _initialized = false;

  // Initialize and load saved users
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load users
      final usersJson = prefs.getString('all_users');
      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        _allUsers = usersList.map((user) => Map<String, dynamic>.from(user)).toList();
        debugPrint('UserManagementService: Loaded ${_allUsers.length} users');
      }
      
      // Load banned users
      final bannedUsersJson = prefs.getString('banned_users');
      if (bannedUsersJson != null) {
        final List<dynamic> bannedList = json.decode(bannedUsersJson);
        _bannedUsers = bannedList.map((email) => email.toString()).toSet();
        debugPrint('UserManagementService: Loaded ${_bannedUsers.length} banned users');
      }
      
      _initialized = true;
    } catch (e) {
      debugPrint('UserManagementService: Error initializing: $e');
      _initialized = true;
    }
  }

  // Save users to persistent storage
  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = json.encode(_allUsers);
      await prefs.setString('all_users', usersJson);
    } catch (e) {
      debugPrint('UserManagementService: Error saving users: $e');
    }
  }

  // Save banned users to persistent storage
  Future<void> _saveBannedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bannedJson = json.encode(_bannedUsers.toList());
      await prefs.setString('banned_users', bannedJson);
    } catch (e) {
      debugPrint('UserManagementService: Error saving banned users: $e');
    }
  }

  // Register a new user (called during sign-up)
  Future<void> registerUser({
    required String email,
    required String name,
    String? profileImageUrl,
  }) async {
    // Check if user already exists
    if (_allUsers.any((user) => user['email'] == email)) {
      return;
    }

    _allUsers.add({
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'registeredAt': DateTime.now().toIso8601String(),
      'isBanned': false,
    });
    
    await _saveUsers();
    debugPrint('UserManagementService: User registered: $email');
  }

  // Get all users
  List<Map<String, dynamic>> getAllUsers() {
    return List.from(_allUsers);
  }

  // Get user by email
  Map<String, dynamic>? getUserByEmail(String email) {
    try {
      return _allUsers.firstWhere((user) => user['email'] == email);
    } catch (e) {
      return null;
    }
  }

  // Ban a user
  Future<void> banUser(String email) async {
    _bannedUsers.add(email);
    // Update user's banned status
    final user = getUserByEmail(email);
    if (user != null) {
      user['isBanned'] = true;
      await _saveUsers();
    }
    await _saveBannedUsers();
    
    // Also update in Firestore
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      
      for (var doc in usersSnapshot.docs) {
        await doc.reference.update({'isBanned': true});
      }
      debugPrint('UserManagementService: User banned in Firestore: $email');
    } catch (e) {
      debugPrint('UserManagementService: Error banning user in Firestore: $e');
    }
    
    debugPrint('UserManagementService: User banned: $email');
  }

  // Unban a user
  Future<void> unbanUser(String email) async {
    _bannedUsers.remove(email);
    // Update user's banned status
    final user = getUserByEmail(email);
    if (user != null) {
      user['isBanned'] = false;
      await _saveUsers();
    }
    await _saveBannedUsers();
    
    // Also update in Firestore
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      
      for (var doc in usersSnapshot.docs) {
        await doc.reference.update({'isBanned': false});
      }
      debugPrint('UserManagementService: User unbanned in Firestore: $email');
    } catch (e) {
      debugPrint('UserManagementService: Error unbanning user in Firestore: $e');
    }
    
    debugPrint('UserManagementService: User unbanned: $email');
  }

  // Check if user is banned
  bool isUserBanned(String email) {
    return _bannedUsers.contains(email);
  }

  // Get banned users count
  int get bannedUsersCount => _bannedUsers.length;

  // Get total users count
  int get totalUsersCount => _allUsers.length;
}

