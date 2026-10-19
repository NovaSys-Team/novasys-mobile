import 'package:flutter/material.dart';

import '../../../theme/parent_home_theme.dart';

class OnboardingSteps extends StatelessWidget {
  const OnboardingSteps({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How it works',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ParentHomeTheme.ink,
          ),
        ),
        const SizedBox(height: 16),
        _StepItem(
          step: 1,
          title: 'Choose a driver',
          subtitle: 'Browse verified drivers serving your school area',
          icon: Icons.person_search_outlined,
          color: ParentHomeTheme.teal,
          isLast: false,
        ),
        _StepItem(
          step: 2,
          title: 'Send request',
          subtitle: 'Submit a transport request with your child\'s details',
          icon: Icons.send_outlined,
          color: ParentHomeTheme.orange,
          isLast: false,
        ),
        _StepItem(
          step: 3,
          title: 'Driver accepted',
          subtitle: 'Once accepted, track the van live every school day',
          icon: Icons.check_circle_outline,
          color: ParentHomeTheme.verified,
          isLast: true,
        ),
      ],
    ),
  );
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isLast,
  });
  final int step;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: ParentHomeTheme.line,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ParentHomeTheme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ParentHomeTheme.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
