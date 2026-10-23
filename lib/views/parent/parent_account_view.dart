import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import 'child_form_view.dart';
import 'child_profile_view.dart';
import 'parent_profile_form_view.dart';
import 'widgets/management_widgets.dart';

class ParentAccountView extends StatelessWidget {
  const ParentAccountView({
    super.key,
    required this.controller,
    this.onSignOut,
  });
  final ParentHomeController controller;
  final ValueChanged<BuildContext>? onSignOut;
  @override
  Widget build(BuildContext context) => ManagementTheme(
    controller: controller,
    child: Builder(
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              const Text(
                'Account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ManagementCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    ProfileAvatar(name: controller.profile.name, size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.profile.name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${controller.profile.phone.isEmpty ? 'No mobile number' : controller.profile.phone} \u00b7 Parent',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => openManagement(
                        context,
                        ParentProfileFormView(controller: controller),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ManagementCard(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'MY CHILDREN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(0, 32),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => openManagement(
                            context,
                            ChildFormView(controller: controller),
                          ),
                          child: const Text('+ Add child'),
                        ),
                      ],
                    ),
                    for (var i = 0; i < controller.children.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        minTileHeight: 56,
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 36,
                        leading: ProfileAvatar(
                          name: controller.children[i].name,
                          size: 36,
                          single: true,
                          color: i.isEven
                              ? const Color(0xFFFFD2C3)
                              : const Color(0xFFCEE7E3),
                        ),
                        title: Text(
                          controller.children[i].name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${controller.children[i].grade} \u00b7 ${controller.transportByChild[controller.children[i].id]?.driverName ?? 'No transport assigned'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        onTap: () {
                          controller.selectChild(i);
                          openManagement(
                            context,
                            ChildProfileView(
                              controller: controller,
                              childId: controller.children[i].id,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ManagementCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    _entry(
                      Icons.settings_outlined,
                      'Account settings',
                      () => openManagement(
                        context,
                        ParentProfileFormView(controller: controller),
                      ),
                    ),
                    const Divider(height: 1),
                    _entry(
                      Icons.notifications_outlined,
                      'Notifications',
                      () => _notifications(context),
                      subtitle: _notificationSummary,
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          _icon(context, Icons.dark_mode_outlined),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Theme',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final dark in [false, true])
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(52, 34),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      backgroundColor:
                                          controller.darkMode == dark
                                          ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                    ),
                                    onPressed: () =>
                                        controller.setDarkMode(dark),
                                    child: Text(
                                      dark ? 'Dark' : 'Light',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ManagementCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    _entry(
                      Icons.chat_bubble_outline,
                      'Help & support',
                      () => _information(
                        context,
                        'Help & support',
                        'For this university demo, manage your parent profile and children from Account. Open a child to view health information and authorized pickup people. Changes are kept for this session only.',
                      ),
                    ),
                    const Divider(height: 1),
                    _entry(
                      Icons.description_outlined,
                      'Terms & conditions',
                      () => _information(
                        context,
                        'Terms & conditions',
                        'NovaSys university presentation prototype. All transport, profile and handover information is mock data. This demonstration does not provide a live transport service.',
                      ),
                    ),
                    const Divider(height: 1),
                    _entry(
                      Icons.shield_outlined,
                      'Privacy policy',
                      () => _information(
                        context,
                        'Privacy policy',
                        'This prototype stores changes in memory for the current session. No profile, child or health information is sent to a server by this module. Restarting the app restores the demo data.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFBA2938),
                ),
                onPressed: () => _signOut(context),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  String get _notificationSummary => controller.pushNotifications
      ? (controller.emailNotifications ? 'Push + email' : 'Push')
      : (controller.emailNotifications ? 'Email' : 'Off');

  Widget _icon(BuildContext context, IconData icon) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, size: 20),
  );

  Widget _entry(
    IconData icon,
    String label,
    VoidCallback onTap, {
    String? subtitle,
  }) => Builder(
    builder: (context) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _icon(context, icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(subtitle, style: const TextStyle(fontSize: 12)),
              ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    ),
  );

  void _information(BuildContext context, String title, String text) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );

  void _notifications(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => ListenableBuilder(
      listenable: controller,
      builder: (context, _) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Push notifications'),
              value: controller.pushNotifications,
              onChanged: (value) => controller.setNotifications(push: value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Email notifications'),
              value: controller.emailNotifications,
              onChanged: (value) => controller.setNotifications(email: value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  );

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Local profile changes will be cleared when you sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed == true) {
      if (onSignOut != null) {
        onSignOut!(context);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign out is available after signing in.'),
          ),
        );
      }
    }
  }
}
