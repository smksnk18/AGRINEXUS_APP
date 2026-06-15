import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Animated AgriNexus logo: a leaf-and-circle mark with fade/scale entrance
/// and a subtle continuous pulse, used on splash and welcome screens.
class AnimatedLogo extends StatefulWidget {
  /// Overall diameter of the logo badge.
  final double size;

  /// Whether to run the gentle looping pulse animation.
  final bool pulse;

  const AnimatedLogo({
    super.key,
    this.size = 120,
    this.pulse = true,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entryController, _pulseController]),
      builder: (context, child) {
        final pulseScale = widget.pulse ? _pulseAnim.value : 1.0;
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value * pulseScale,
            child: _buildLogo(),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F6653), Color(0xFF012D1D)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle inner ring
          Container(
            width: widget.size * 0.86,
            height: widget.size * 0.86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
          ),
          // Leaf + wheat motif using icons for simplicity & portability
          Icon(
            Icons.eco_rounded,
            size: widget.size * 0.5,
            color: AppColors.tertiaryContainer,
          ),
          Positioned(
            top: widget.size * 0.16,
            right: widget.size * 0.14,
            child: Icon(
              Icons.grain_rounded,
              size: widget.size * 0.26,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
