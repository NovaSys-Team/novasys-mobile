import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../theme/parent_home_theme.dart';
import 'new_parent_home_view.dart';
import 'parent_home_view.dart';
import 'parent_account_view.dart';
import 'widgets/parent_bottom_nav.dart';

class ParentHomeShell extends StatelessWidget {
  const ParentHomeShell({super.key, required this.controller, this.onSignOut});
  final ParentHomeController controller;
  final ValueChanged<BuildContext>? onSignOut;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context)
        .copyWith(scaffoldBackgroundColor: ParentHomeTheme.soft),
    child: Scaffold(
      backgroundColor: ParentHomeTheme.soft,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.bottomNavIndex == 4) {
              return ParentAccountView(
                controller: controller,
                onSignOut: onSignOut,
              );
            }
            if (controller.bottomNavIndex != 0) {
              return _PlaceholderTab(
                label: _tabLabel(controller.bottomNavIndex),
              );
            }
            if (controller.isNewParent) {
              return NewParentHomeView(controller: controller);
            }
            return ParentHomeView(controller: controller);
          },
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => ParentBottomNav(
          currentIndex: controller.bottomNavIndex,
          onTap: controller.selectNavTab,
        ),
      ),
    ),
  );

  String _tabLabel(int index) => switch (index) {
    1 => 'Track',
    2 => 'Payments',
    3 => 'Alerts',
    4 => 'Account',
    _ => 'Home',
  };
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.construction, size: 48, color: ParentHomeTheme.muted),
        const SizedBox(height: 12),
        Text(
          '$label — coming soon',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ParentHomeTheme.muted,
          ),
        ),
      ],
    ),
  );
}
