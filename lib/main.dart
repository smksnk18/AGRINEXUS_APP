import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'services/app_state_provider.dart';
import 'paddy_guide_controller.dart';
import 'utils/app_routes.dart';
import 'utils/theme.dart';
import 'models/eatgood_product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(EatGoodProductAdapter());

  await Hive.openBox<EatGoodProduct>('products');

  debugPrint(
      "BOX LENGTH = ${Hive.box<EatGoodProduct>('products').length}");

  for (var p in Hive.box<EatGoodProduct>('products').values) {
    debugPrint("${p.productName} : ${p.productId}");
  }

  runApp(const AgriNexusApp());
}

class AgriNexusApp extends StatelessWidget {
  const AgriNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
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