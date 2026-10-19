import 'package:flutter/material.dart';

import '../../../models/parent_models.dart';
import '../../../theme/parent_home_theme.dart';

class VerifiedDriversSection extends StatelessWidget {
  const VerifiedDriversSection({super.key, required this.drivers});
  final List<DriverInfo> drivers;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Verified drivers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ParentHomeTheme.ink,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('View all drivers — coming soon'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ),
                  );
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ParentHomeTheme.teal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < drivers.length; i++) ...[
          _DriverTile(driver: drivers[i]),
          if (i < drivers.length - 1) const SizedBox(height: 10),
        ],
      ],
    ),
  );
}

class _DriverTile extends StatelessWidget {
  const _DriverTile({required this.driver});
  final DriverInfo driver;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: ParentHomeTheme.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ParentHomeTheme.line),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: ParentHomeTheme.soft,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: ParentHomeTheme.muted,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      driver.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ParentHomeTheme.ink,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (driver.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: ParentHomeTheme.verified,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${driver.vehicleNumber}  •  ${driver.school}',
                style: const TextStyle(
                  fontSize: 12,
                  color: ParentHomeTheme.muted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                const SizedBox(width: 2),
                Text(
                  driver.rating.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ParentHomeTheme.ink,
                  ),
                ),
              ],
            ),
            Text(
              '${driver.totalTrips} trips',
              style: const TextStyle(
                fontSize: 11,
                color: ParentHomeTheme.muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
