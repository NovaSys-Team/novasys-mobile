import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../theme/auth_theme.dart';
import 'auth_form_view.dart';
import 'registration_view.dart';
import 'widgets/welcome_hero.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({
    super.key,
    required this.controller,
    this.identityVerified = false,
  });
  final AuthController controller;
  final bool identityVerified;
  @override
  Widget build(BuildContext context) => Theme(
    data: AuthTheme.light,
    child: Scaffold(
      body: SafeArea(
        child: Center(
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
                        WelcomeHero(onBack: () => Navigator.pop(context)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Text(
                            'I am a',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: ListenableBuilder(
                            listenable: controller,
                            builder: (context, _) => Row(
                              children: [
                                for (final role in UserRole.values) ...[
                                  if (role == UserRole.driver)
                                    const SizedBox(width: 10),
                                  Expanded(
                                    child: Semantics(
                                      button: true,
                                      selected: controller.role == role,
                                      child: Material(
                                        color: controller.role == role
                                            ? AuthTheme.mint
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          side: BorderSide(
                                            color: controller.role == role
                                                ? AuthTheme.teal
                                                : AuthTheme.line,
                                            width: controller.role == role
                                                ? 1.6
                                                : 1,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: () =>
                                              controller.selectRole(role),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    controller.role == role
                                                        ? Icons
                                                              .radio_button_checked
                                                        : Icons
                                                              .radio_button_off,
                                                    size: 18,
                                                    color:
                                                        controller.role == role
                                                        ? AuthTheme.teal
                                                        : AuthTheme.muted,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        role == UserRole.parent
                                                            ? Icons
                                                                  .people_outline
                                                            : Icons
                                                                  .directions_bus_outlined,
                                                        size: 24,
                                                        color:
                                                            controller.role ==
                                                                role
                                                            ? AuthTheme.teal
                                                            : AuthTheme.muted,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        role.label,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AuthTheme.ink,
                                                        ),
                                                      ),
                                                      Text(
                                                        role == UserRole.parent
                                                            ? 'Find a van for my child'
                                                            : 'I drive a school van',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                        ),
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
                                ],
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: FilledButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => identityVerified
                                    ? RegistrationView(controller: controller)
                                    : AuthFormView(
                                        controller: controller,
                                        roleSelected: true,
                                      ),
                              ),
                            ),
                            child: const Text('Continue'),
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
    ),
  );
}
