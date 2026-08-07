import 'package:flutter/material.dart';

class PremiumLogo extends StatelessWidget {
  final double size;
  final bool showSubtitle;

  const PremiumLogo({
    super.key,
    this.size = 90,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 3),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6C63FF),
                Color(0xFF00C2FF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: Colors.white,
            size: 46,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          "JB Creator AI",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (showSubtitle) ...[
          const SizedBox(height: 8),

          const Text(
            "Create • Manage • Grow",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ],
    );
  }
}