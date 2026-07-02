import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';

/// App-wide session state managed via Provider.
class AppStateProvider extends ChangeNotifier {

  UserRole _selectedRole = UserRole.none;
  AppUser? _currentUser;
  bool _rememberMe = false;
  bool _isDarkMode = false;

  UserRole get selectedRole => _selectedRole;
  AppUser? get currentUser => _currentUser;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _currentUser != null;
  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", _isDarkMode);

    notifyListeners();
  }

  Future<void> setTheme(bool value) async {
    _isDarkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", value);

    notifyListeners();
  }

  /// Called when the user picks Farmer or Consumer on the welcome screen.
  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  /// Simulates a login and stores session info.
  Future<void> login({
    required String name,
    required String identifier,
    required UserRole role,
    bool rememberMe = false,
  }) async {
    _currentUser = AppUser(name: name, identifier: identifier, role: role);
    _rememberMe = rememberMe;

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_identifier', identifier);
      await prefs.setString('user_role', role.name);
      await prefs.setBool('remember_me', true);
    }
    notifyListeners();
  }

  /// Loads any previously remembered session from SharedPreferences.
  Future<void> loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    final remembered = prefs.getBool('remember_me') ?? false;
    if (remembered) {
      final identifier = prefs.getString('user_identifier');
      final roleName = prefs.getString('user_role');
      if (identifier != null && roleName != null) {
        _rememberMe = true;
        _selectedRole =
        roleName == 'farmer' ? UserRole.farmer : UserRole.consumer;
        _currentUser = AppUser(
          name: 'Welcome Back',
          identifier: identifier,
          role: _selectedRole,
        );
      }
    }
    notifyListeners();
  }

  /// Logs the user out and clears persisted session data.
  Future<void> logout() async {
    _currentUser = null;
    _selectedRole = UserRole.none;
    _rememberMe = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
