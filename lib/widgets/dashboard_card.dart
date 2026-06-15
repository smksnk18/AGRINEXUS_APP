import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  final int index;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
    required this.index,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isAnimating = false;
  double scale = 1;
  bool visible = false;
  double shadowBlur = 15;
  double shadowOffset = 8;
  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: widget.index * 120),
          () {
        if (mounted) {
          setState(() {
            visible = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: visible ? 1 : 0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, 0.25),
          child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: scale,
        child: Hero(
          tag: widget.title,
          child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.white24,
            onTap: () async {
              if (isAnimating) return;

              isAnimating = true;

              setState(() {
                scale = 0.93;
                shadowBlur = 25;
                shadowOffset = 15;
              });

              await Future.delayed(
                const Duration(milliseconds: 100),
              );

              setState(() {
                scale = 1;
                shadowBlur = 15;
                shadowOffset = 8;
              });

              isAnimating = false;

              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: widget.colors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: shadowBlur,
                    offset: Offset(0, shadowOffset),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
        ),
        ),
    );
  }
}