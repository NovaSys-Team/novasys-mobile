import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import 'entry_views.dart';
import 'parent/parent_preview.dart';

void openDashboard(BuildContext context, AuthController controller) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => controller.role == UserRole.parent
            ? const ParentHomePreview()
            : DashboardView(controller: controller),
      ),
      (_) => false,
    );

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.controller});
  final AuthController controller;
  @override
  Widget build(BuildContext context) {
    final user = controller.user!;
    return Scaffold(
      appBar: AppBar(title: Text('${user.role.label} dashboard')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppTheme.teal,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome, ${user.name}.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  user.role == UserRole.parent
                      ? 'A calmer school day starts here.'
                      : 'Ready for a better school run.',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your dashboard is coming soon. This is a local '
                  'authentication demo.',
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    controller.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => InitialView(controller: controller),
                      ),
                      (_) => false,
                    );
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
