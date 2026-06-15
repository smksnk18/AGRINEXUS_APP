import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/app_state_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/animated_logo.dart';
import '../widgets/role_card.dart';
import '../widgets/feature_tile.dart';

/// Welcome screen - the entry point where users choose their role
/// (Farmer or Consumer) before logging in.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeIn);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  void _selectRole(BuildContext context, UserRole role) {
    context.read<AppStateProvider>().selectRole(role);
    Navigator.of(context).pushNamed(
      role == UserRole.farmer
          ? AppRoutes.farmerLogin
          : AppRoutes.consumerLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 720;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient agriculture-themed background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.welcomeGradient),
          ),
          // Decorative blurred shapes for depth
          Positioned(
            top: -60,
            right: -40,
            child: _blurCircle(180, AppColors.tertiaryContainer.withOpacity(0.25)),
          ),
          Positioned(
            bottom: 80,
            left: -60,
            child: _blurCircle(220, AppColors.gold.withOpacity(0.15)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                children: [
                  // Hero logo - matches splash screen tag for smooth transition
                  Hero(
                    tag: 'agrinexus-logo',
                    child: const AnimatedLogo(size: 84),
                  ),
                  const SizedBox(height: 20),

                  // Header text with fade + slide animation
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: Column(
                        children: [
                          const Text(
                            'Welcome to AgriNexus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'A premium marketplace connecting farmers directly '
                            'with consumers — fresh produce, fair prices, and '
                            'full transparency from farm to table.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.5,
                              color: Colors.white.withOpacity(0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Role selection cards
                  isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _farmerCard(context)),
                            const SizedBox(width: 20),
                            Expanded(child: _consumerCard(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _farmerCard(context),
                            const SizedBox(height: 20),
                            _consumerCard(context),
                          ],
                        ),

                  const SizedBox(height: 44),

                  // "Why AgriNexus" feature section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Why AgriNexus?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _featureGrid(isWide),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _farmerCard(BuildContext context) {
    return RoleCard(
      icon: Icons.agriculture_rounded,
      title: 'Farmer',
      accentColor: AppColors.tertiaryContainer,
      animationDelayMs: 150,
      features: const [
        'Sell Produce',
        'Manage Inventory',
        'Track Orders',
      ],
      onContinue: () => _selectRole(context, UserRole.farmer),
    );
  }

  Widget _consumerCard(BuildContext context) {
    return RoleCard(
      icon: Icons.shopping_basket_rounded,
      title: 'Consumer',
      accentColor: AppColors.gold,
      animationDelayMs: 300,
      features: const [
        'Buy Fresh Produce',
        'Track Deliveries',
        'Direct Farmer Access',
      ],
      onContinue: () => _selectRole(context, UserRole.consumer),
    );
  }

  Widget _featureGrid(bool isWide) {
    final features = const [
      (Icons.lock_rounded, 'Secure Payments', 'Encrypted, trusted transactions'),
      (Icons.visibility_rounded, 'Transparent Sourcing', 'Know exactly where food comes from'),
      (Icons.eco_rounded, 'Sustainable Farming', 'Supporting eco-friendly practices'),
      (Icons.storefront_rounded, 'Direct Marketplace', 'Farmer-to-consumer, no middlemen'),
    ];

    if (isWide) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: features
            .asMap()
            .entries
            .map((e) => SizedBox(
                  width: 320,
                  child: FeatureTile(
                    icon: e.value.$1,
                    title: e.value.$2,
                    subtitle: e.value.$3,
                    animationDelayMs: e.key * 100,
                  ),
                ))
            .toList(),
      );
    }

    return Column(
      children: features
          .asMap()
          .entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FeatureTile(
                  icon: e.value.$1,
                  title: e.value.$2,
                  subtitle: e.value.$3,
                  animationDelayMs: e.key * 100,
                ),
              ))
          .toList(),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
