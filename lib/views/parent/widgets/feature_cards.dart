import 'package:flutter/material.dart';

import '../../../theme/parent_home_theme.dart';

class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        _FeatureCard(
          icon: Icons.event_busy_outlined,
          label: 'Mark\nabsent',
          color: const Color(0xFFFFF4EF),
          iconColor: ParentHomeTheme.orange,
          onTap: () => _showSnack(context, 'Mark absent'),
        ),
        const SizedBox(width: 12),
        _FeatureCard(
          icon: Icons.person_search_outlined,
          label: 'Find\ndriver',
          color: ParentHomeTheme.mint,
          iconColor: ParentHomeTheme.teal,
          onTap: () => _showSnack(context, 'Find driver'),
        ),
        const SizedBox(width: 12),
        _FeatureCard(
          icon: Icons.history,
          label: 'History',
          color: const Color(0xFFF0F0FF),
          iconColor: const Color(0xFF5B5FC7),
          onTap: () => _showSnack(context, 'History'),
        ),
      ],
    ),
  );

  void _showSnack(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature — coming soon'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ParentHomeTheme.ink,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
