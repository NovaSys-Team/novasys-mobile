import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import '../theme/auth_theme.dart';
import 'parent/parent_preview.dart';
import 'role_selection_view.dart';
import 'driver_verification_view.dart';
import 'widgets/welcome_hero.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key, required this.controller});
  final AuthController controller;
  @override
  Widget build(BuildContext context) => Theme(
    data: AuthTheme.light,
    child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WelcomeHero(onBack: () => Navigator.maybePop(context)),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Safe rides to school,\nevery day',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Track the van live, get boarding and drop-off alerts, and manage absences and payments in one place.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: AuthTheme.muted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          for (final language in [
                            ('English', 'English'),
                            ('සිංහල', 'Sinhala'),
                            ('தமிழ்', 'Tamil'),
                          ])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Semantics(
                                selected: controller.language == language.$2,
                                child: Material(
                                  color: controller.language == language.$2
                                      ? AuthTheme.mint
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: controller.language == language.$2
                                          ? AuthTheme.teal
                                          : AuthTheme.line,
                                      width: controller.language == language.$2
                                          ? 1.5
                                          : 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () =>
                                        controller.selectLanguage(language.$2),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  language.$1,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: AuthTheme.ink,
                                                  ),
                                                ),
                                                Text(
                                                  language.$2,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            controller.language == language.$2
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color:
                                                controller.language ==
                                                    language.$2
                                                ? AuthTheme.teal
                                                : AuthTheme.muted,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    RoleSelectionView(controller: controller),
                              ),
                            ),
                            child: const Text('Continue'),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'You can change language later in Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

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
    if (user.role == UserRole.driver) {
      return DriverVerificationView(auth: controller);
    }
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
                  'Your dashboard is coming soon. This is a local authentication demo.',
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    controller.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => WelcomeView(controller: controller),
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
