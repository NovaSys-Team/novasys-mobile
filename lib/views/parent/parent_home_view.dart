import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../theme/parent_home_theme.dart';
import 'widgets/child_selector.dart';
import 'widgets/feature_cards.dart';
import 'widgets/fees_section.dart';
import 'widgets/track_van_card.dart';
import 'widgets/transport_card.dart';

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({super.key, required this.controller});
  final ParentHomeController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final transport = controller.selectedTransport;
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(controller: controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: ChildSelector(
              children: controller.children,
              selectedIndex: controller.selectedChildIndex,
              onSelect: controller.selectChild,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          if (transport != null) ...[
            SliverToBoxAdapter(
              child: TransportCard(
                child_: controller.selectedChild,
                transport: transport,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(
              child: TrackVanCard(
                transport: transport,
                onTap: () => _showSnack(context, 'Track van'),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(child: FeatureCards()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: FeesSection(
              fee: controller.currentFee,
              onPay: () => controller.selectNavTab(2),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );
    },
  );

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('$msg — coming soon'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final ParentHomeController controller;

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
                'Good morning',
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
