import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state_provider.dart';
import 'utils/app_routes.dart';
import 'utils/theme.dart';

/// Entry point for the AgriNexus application.
void main() {
  runApp(const AgriNexusApp());
}

/// Root widget of the AgriNexus app.
///
/// Sets up Provider-based state management, Material 3 theming,
/// and named-route navigation starting from the Splash screen.
class AgriNexusApp extends StatelessWidget {
  const AgriNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: MaterialApp(
        title: 'AgriNexus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
