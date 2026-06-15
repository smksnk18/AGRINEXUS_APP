import 'package:flutter/material.dart';
import '../screens/dashboard_page.dart';
import '../screens/home_page.dart';
import '../screens/settings_page.dart';
import '../screens/notifications_page.dart';
import '../screens/profile_page.dart';
import '../screens/market_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String market = '/market';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const DashboardPage(), // Using DashboardPage as splash for now
    dashboard: (context) => const DashboardPage(),
    home: (context) => const HomePage(),
    settings: (context) => const SettingsPage(),
    notifications: (context) => const NotificationsPage(),
    profile: (context) => const ProfilePage(),
    market: (context) => const MarketPage(),
  };
}
