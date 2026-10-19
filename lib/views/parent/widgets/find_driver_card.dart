import 'package:flutter/material.dart';

import '../../../theme/parent_home_theme.dart';

class FindDriverCard extends StatelessWidget {
  const FindDriverCard({super.key, this.onSearch});
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: ParentHomeTheme.darkGreen,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.directions_bus_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Find a school van',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Search for verified drivers near your school and send a transport request.',
          style: TextStyle(
            color: Colors.white.withAlpha(178),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onSearch,
            icon: const Icon(Icons.search, size: 18),
            label: const Text('Search drivers'),
            style: FilledButton.styleFrom(
              backgroundColor: ParentHomeTheme.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
