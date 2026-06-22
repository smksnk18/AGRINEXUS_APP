import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state_provider.dart';
import 'paddy_guide_controller.dart'; // Import the new controller here
import 'utils/app_routes.dart';
import 'utils/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/eatgood_product_model.dart';

/// Entry point for the AgriNexus application.
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(
    EatGoodProductAdapter(),
  );

  await Hive.openBox<EatGoodProduct>(
    'products',
  );
  debugPrint(
      "BOX LENGTH = ${Hive.box<EatGoodProduct>('products').length}");
  for (var p in Hive.box<EatGoodProduct>('products').values) {
    debugPrint(
        "${p.productName} : ${p.productId}");
  }

  runApp(
    const AgriNexusApp(),
  );

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
        // Your existing global state manager remains completely untouched
        ChangeNotifierProvider(create: (_) => AppStateProvider()),

        // New controller appended seamlessly to the provider chain
        ChangeNotifierProvider(create: (_) => PaddyGuideController()),
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