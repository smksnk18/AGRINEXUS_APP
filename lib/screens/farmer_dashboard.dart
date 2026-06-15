import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

/// Placeholder dashboard for logged-in Farmers.
///
/// Shows a welcome banner, key stats (products, orders, revenue),
/// and inventory management cards.
class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  void _logout(BuildContext context) async {
    await context.read<AppStateProvider>().logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.welcome,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 720;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / welcome banner
              _fadeIn(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: AppColors.greenButtonGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.agriculture_rounded,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome, Farmer 🌱',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Here\'s how your farm is performing today.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout_rounded, color: Colors.white),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stat cards
              isWide
                  ? Row(
                      children: [
                        Expanded(child: _statCard('Total Products', '128', Icons.inventory_2_rounded, AppColors.primaryContainer, 0)),
                        const SizedBox(width: 16),
                        Expanded(child: _statCard('Orders', '42', Icons.receipt_long_rounded, AppColors.secondaryContainer, 100)),
                        const SizedBox(width: 16),
                        Expanded(child: _statCard('Revenue', '₹86,400', Icons.payments_rounded, AppColors.tertiaryContainer, 200)),
                      ],
                    )
                  : Column(
                      children: [
                        _statCard('Total Products', '128', Icons.inventory_2_rounded, AppColors.primaryContainer, 0),
                        const SizedBox(height: 14),
                        _statCard('Orders', '42', Icons.receipt_long_rounded, AppColors.secondaryContainer, 100),
                        const SizedBox(height: 14),
                        _statCard('Revenue', '₹86,400', Icons.payments_rounded, AppColors.tertiaryContainer, 200),
                      ],
                    ),

              const SizedBox(height: 28),
              const Text(
                'Inventory Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  _inventoryCard('Add Product', Icons.add_box_rounded, AppColors.primaryContainer, 0),
                  _inventoryCard('My Listings', Icons.list_alt_rounded, AppColors.secondaryContainer, 100),
                  _inventoryCard('Order Requests', Icons.shopping_cart_checkout_rounded, AppColors.tertiaryContainer, 200),
                  _inventoryCard('Analytics', Icons.show_chart_rounded, AppColors.gold, 300),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, int delay) {
    return _fadeIn(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.onSurfaceVariant.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inventoryCard(String label, IconData icon, Color color, int delay) {
    return _fadeIn(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fadeIn({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, c) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * 16), child: c),
      ),
      child: child,
    );
  }
}
