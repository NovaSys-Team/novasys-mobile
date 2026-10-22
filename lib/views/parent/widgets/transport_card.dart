import 'package:flutter/material.dart';

import '../../../models/parent_models.dart';
import '../../../theme/parent_home_theme.dart';

class TransportCard extends StatelessWidget {
  const TransportCard({
    super.key,
    required this.child_,
    required this.transport,
  });
  final Child child_;
  final TransportInfo transport;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ParentHomeTheme.darkGreen,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1A4F4E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_bus_outlined,
                color: Colors.white70,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'School Transport',
                    style: TextStyle(
                      color: Colors.white.withAlpha(178),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    child_.school,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _InfoPill(icon: Icons.access_time, label: transport.boardingTime),
            const SizedBox(width: 10),
            _InfoPill(icon: Icons.event_seat, label: transport.seatNumber),
          ],
        ),
        const SizedBox(height: 10),
        _InfoPill(icon: Icons.route, label: transport.routeName),
      ],
    ),
  );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
