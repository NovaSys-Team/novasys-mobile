import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../theme/auth_theme.dart';
import 'auth_form_view.dart';
import 'role_selection_view.dart';
import 'widgets/auth_details.dart';
import 'widgets/welcome_hero.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.controller});
  final AuthController controller;
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => InitialView(controller: widget.controller),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AuthTheme.deep,
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(child: NovaSysMark(size: 26)),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'NovaSys',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AuthTheme.soft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// P01 — Welcome. Illustrated dark header over the value proposition and the
/// two entry points into the email authentication flow.
class InitialView extends StatelessWidget {
  const InitialView({super.key, required this.controller});
  final AuthController controller;

  void _open(BuildContext context, Widget Function() build) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => build()));

  /// The reference header band is 62% of the frame. Give it whatever the copy
  /// and the two buttons do not need, so they stay above the fold on shorter
  /// screens, and never let it grow past that reference share.
  static double _headerHeight(double available) {
    final cap = available * .62;
    final flexible = available - 340;
    final height = flexible < 240 ? 240.0 : flexible;
    return height > cap ? cap : height;
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: AuthTheme.light,
    child: Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WelcomeHeader(
                        height: _headerHeight(constraints.maxHeight),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe rides to school, every day',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontSize: 32),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Track the van live, get boarding and drop-off '
                              'alerts, and manage absences and payments in one '
                              'place.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: AuthTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton(
                              onPressed: () => _open(
                                context,
                                () => RoleSelectionView(controller: controller),
                              ),
                              child: const Text('Get started'),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => _open(
                                context,
                                () => AuthFormView(controller: controller),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                foregroundColor: AuthTheme.teal,
                                side: const BorderSide(color: AuthTheme.teal),
                                textStyle: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('I already have an account'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
