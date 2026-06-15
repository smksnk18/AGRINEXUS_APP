import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Premium gradient/outline button used throughout AgriNexus.
///
/// Supports a primary (filled gradient) style and a secondary
/// (outlined) style, plus an optional leading icon and loading state.
class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isLoading;
  final Gradient? gradient;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
    this.gradient,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: widget.isOutlined
                  ? AppColors.primaryContainer
                  : Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    size: 20,
                    color: widget.textColor ??
                        (widget.isOutlined
                            ? AppColors.primaryContainer
                            : Colors.white)),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: widget.textColor ??
                      (widget.isOutlined
                          ? AppColors.primaryContainer
                          : Colors.white),
                ),
              ),
            ],
          );

    final button = AnimatedBuilder(
      animation: _scale,
      builder: (context, c) => Transform.scale(scale: _scale.value, child: c),
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: widget.isOutlined
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant),
                color: Colors.transparent,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: widget.gradient ?? AppColors.greenButtonGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
        child: child,
      ),
    );

    return GestureDetector(
      onTapDown: widget.onPressed == null ? null : _onTapDown,
      onTapUp: widget.onPressed == null ? null : _onTapUp,
      onTapCancel: widget.onPressed == null ? null : _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: button,
    );
  }
}
