import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_user.dart';
import '../../services/app_state_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../register/consumer_register.dart';
import '../buyer/dashboard_page.dart';


/// Login screen for Consumers.
///
/// Includes email + password login, "Remember Me", "Forgot Password",
/// Google Sign-In placeholder, and a register option.
class ConsumerLoginScreen extends StatefulWidget {
  const ConsumerLoginScreen({super.key});

  @override
  State<ConsumerLoginScreen> createState() => _ConsumerLoginScreenState();
}

class _ConsumerLoginScreenState extends State<ConsumerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900)); // simulate network

    if (!mounted) return;
    await context.read<AppStateProvider>().login(
          name: 'Consumer',
          identifier: _emailController.text.trim(),
          role: UserRole.consumer,
          rememberMe: _rememberMe,
        );

    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  void _showPlaceholder(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _backButton(),
                const SizedBox(height: 12),
                _animatedHeader(),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _fadeSlideIn(
                        delay: 0,
                        child: CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
                            if (!emailRegex.hasMatch(val.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _fadeSlideIn(
                        delay: 100,
                        child: CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Password is required';
                            }
                            if (val.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) =>
                                      setState(() => _rememberMe = val ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => _showPlaceholder('Forgot password'),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _fadeSlideIn(
                        delay: 200,
                        child: CustomButton(
                          label: 'Login',
                          icon: Icons.login_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                          gradient: AppColors.goldGradient,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _fadeSlideIn(
                        delay: 250,
                        child: CustomButton(
                          label: 'Register as Consumer',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  RegisterPage(
                                  userType : "Consumer",
                                ),
                              ),

                            );
                          },                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _orDivider(),
                const SizedBox(height: 20),
                _fadeSlideIn(
                  delay: 300,
                  child: CustomButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    isOutlined: true,
                    onPressed: () => _showPlaceholder('Google Sign-In'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
      ),
    );
  }

  Widget _animatedHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * 16), child: child),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_basket_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 18),
          const Text(
            'Consumer Login',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to discover fresh produce straight from local farms.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.outline,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outlineVariant)),
      ],
    );
  }

  Widget _fadeSlideIn({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, c) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * 14), child: c),
      ),
      child: child,
    );
  }
}
