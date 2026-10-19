import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../theme/parent_home_theme.dart';
import 'parent_home_shell.dart';

class ParentHomePreview extends StatefulWidget {
  const ParentHomePreview({super.key});

  @override
  State<ParentHomePreview> createState() => _ParentHomePreviewState();
}

class _ParentHomePreviewState extends State<ParentHomePreview> {
  bool _isNewParent = false;
  late ParentHomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ParentHomeController(isNewParent: _isNewParent);
  }

  void _toggle() {
    _controller.dispose();
    setState(() {
      _isNewParent = !_isNewParent;
      _controller = ParentHomeController(isNewParent: _isNewParent);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ParentHomeShell(controller: _controller),
      Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Tooltip(
            message: _isNewParent
                ? 'Switch to Existing Parent (P03)'
                : 'Switch to New Parent (P03A)',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _toggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ParentHomeTheme.ink.withAlpha(204),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      _isNewParent ? 'P03A' : 'P03',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
