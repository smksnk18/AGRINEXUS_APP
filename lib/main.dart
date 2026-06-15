import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state_provider.dart';
import 'utils/app_routes.dart';
import 'utils/theme.dart';

void main() {
  runApp(const AgriNexusApp());
}

class AgriNexusApp extends StatelessWidget {
  const AgriNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'AgriNexus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
