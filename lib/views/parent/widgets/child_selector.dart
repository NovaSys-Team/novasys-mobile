import 'package:flutter/material.dart';

import '../../../models/parent_models.dart';
import '../../../theme/parent_home_theme.dart';

class ChildSelector extends StatelessWidget {
  const ChildSelector({
    super.key,
    required this.children,
    required this.selectedIndex,
    required this.onSelect,
  });
  final List<Child> children;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final selected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? ParentHomeTheme.teal : ParentHomeTheme.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? ParentHomeTheme.teal : ParentHomeTheme.line,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: selected
                      ? ParentHomeTheme.white
                      : ParentHomeTheme.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  children[index].name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? ParentHomeTheme.white
                        : ParentHomeTheme.ink,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
