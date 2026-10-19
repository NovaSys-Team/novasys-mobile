import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../theme/parent_home_theme.dart';
import 'widgets/find_driver_card.dart';
import 'widgets/onboarding_steps.dart';
import 'widgets/verified_drivers.dart';

class NewParentHomeView extends StatelessWidget {
  const NewParentHomeView({super.key, required this.controller});
  final ParentHomeController controller;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: _Header()),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(
        child: FindDriverCard(
          onSearch: () {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Search drivers — coming soon'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),
      const SliverToBoxAdapter(child: OnboardingSteps()),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),
      SliverToBoxAdapter(
        child: VerifiedDriversSection(drivers: controller.verifiedDrivers),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ],
  );
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(fontSize: 13, color: ParentHomeTheme.muted),
              ),
              const SizedBox(height: 2),
              const Text(
                'Mrs. Perera',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: ParentHomeTheme.ink,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ParentHomeTheme.soft,
            shape: BoxShape.circle,
            border: Border.all(color: ParentHomeTheme.line),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            size: 20,
            color: ParentHomeTheme.muted,
          ),
        ),
      ],
    ),
  );
}
