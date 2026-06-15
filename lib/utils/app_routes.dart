import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/farmer_login.dart';
import '../screens/consumer_login.dart';
import '../screens/farmer_dashboard.dart';
import '../screens/consumer_dashboard.dart';

/// Centralized named-route definitions and route generator for AgriNexus.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String farmerLogin = '/farmer-login';
  static const String consumerLogin = '/consumer-login';
  static const String farmerDashboard = '/farmer-dashboard';
  static const String consumerDashboard = '/consumer-dashboard';

  /// Map of route names to widget builders.
  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        welcome: (context) => const WelcomeScreen(),
        farmerLogin: (context) => const FarmerLoginScreen(),
        consumerLogin: (context) => const ConsumerLoginScreen(),
        farmerDashboard: (context) => const FarmerDashboardScreen(),
        consumerDashboard: (context) => const ConsumerDashboardScreen(),
      };
}
