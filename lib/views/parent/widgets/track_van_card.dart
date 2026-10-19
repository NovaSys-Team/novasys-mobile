import 'package:flutter/material.dart';

import '../../../models/parent_models.dart';
import '../../../theme/parent_home_theme.dart';

class TrackVanCard extends StatelessWidget {
  const TrackVanCard({super.key, required this.transport, this.onTap});
  final TransportInfo transport;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ParentHomeTheme.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track van',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transport.eta != null
                      ? 'Arrives in ${transport.eta}'
                      : transport.status == TransportStatus.scheduled
                      ? 'Scheduled'
                      : 'En route',
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white, size: 24),
        ],
      ),
    ),
  );
}
