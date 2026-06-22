import 'package:flutter/material.dart';
import '../screens/farmer_login/splash_screen.dart';
import '../screens/farmer_login/welcome_screen.dart';
import '../screens/farmer_login/farmer_login.dart';
import '../screens/farmer_login/consumer_login.dart';
import '../screens/farmer_dashboard/dashboard_page.dart';
import '../screens/farmer_login/consumer_dashboard.dart';
import '../screens/farmer_dashboard/home_page.dart';
import '../screens/farmer_dashboard/settings_page.dart';
import '../screens/farmer_dashboard/notifications_page.dart';
import '../screens/farmer_dashboard/profile_page.dart';
import '../screens/farmer_dashboard/market_page.dart';

/// Centralized named-route definitions and route generator for AgriNexus.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String farmerLogin = '/farmer-login';
  static const String consumerLogin = '/consumer-login';
  static const String dashboard = '/dashboard';
  static const String consumerDashboard = '/consumer-dashboard';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String market = '/market';

  /// Map of route names to widget builders.
  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        welcome: (context) => const WelcomeScreen(),
        farmerLogin: (context) => const FarmerLoginScreen(),
        consumerLogin: (context) => const ConsumerLoginScreen(),
        dashboard: (context) => const DashboardPage(),
    consumerDashboard: (context) => const ConsumerDashboard(),
        home: (context) => const HomePage(),
        settings: (context) => const SettingsPage(),
        notifications: (context) => const NotificationsPage(),
        profile: (context) => const ProfilePage(),
        market: (context) => const MarketPage(),
      };
}
