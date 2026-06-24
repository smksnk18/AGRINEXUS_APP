import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

/// Placeholder dashboard for logged-in Consumers.
///
/// Shows a welcome banner, search bar, product categories,
/// and quick-access cards for cart and orders.
class ConsumerDashboard extends StatelessWidget {
  const ConsumerDashboard({super.key});

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

    final categories = [
      ('Vegetables', Icons.eco_rounded),
      ('Fruits', Icons.apple_rounded),
      ('Grains', Icons.grain_rounded),
      ('Dairy', Icons.icecream_rounded),
      ('Spices', Icons.local_fire_department_rounded),
      ('More', Icons.grid_view_rounded),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              _fadeIn(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shopping_basket_rounded,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome, Consumer 🛒',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fresh produce from local farms, just for you.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
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
              const SizedBox(height: 22),

              // Search bar
              _fadeIn(
                delay: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for fresh produce...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primaryContainer),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // Categories
              const Text(
                'Categories',
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
                crossAxisCount: isWide ? 6 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: categories
                    .asMap()
                    .entries
                    .map((e) => _categoryCard(e.value.$1, e.value.$2, e.key * 80))
                    .toList(),
              ),
              const SizedBox(height: 28),

              // Cart / Orders quick access
              const Text(
                'Your Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              isWide
                  ? Row(
                children: [
                  Expanded(child: _activityCard('My Cart', '3 items', Icons.shopping_cart_rounded, AppColors.primaryContainer, 0)),
                  const SizedBox(width: 16),
                  Expanded(child: _activityCard('My Orders', '2 active', Icons.local_shipping_rounded, AppColors.secondaryContainer, 100)),
                ],
              )
                  : Column(
                children: [
                  _activityCard('My Cart', '3 items', Icons.shopping_cart_rounded, AppColors.primaryContainer, 0),
                  const SizedBox(height: 14),
                  _activityCard('My Orders', '2 active', Icons.local_shipping_rounded, AppColors.secondaryContainer, 100),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String label, IconData icon, int delay) {
    return _fadeIn(
      delay: delay,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryContainer, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityCard(String title, String subtitle, IconData icon, Color color, int delay) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
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
