import 'package:flutter/material.dart';

import '../../../controllers/parent_home_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/parent_home_theme.dart';

String initials(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .where((s) => s.isNotEmpty)
    .take(2)
    .map((s) => s[0])
    .join()
    .toUpperCase();
String birthDate(DateTime? date) {
  if (date == null) return 'Not provided';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

/// Keeps account routes in the parent's local theme without changing Driver/auth.
class ManagementTheme extends StatelessWidget {
  const ManagementTheme({
    super.key,
    required this.controller,
    required this.child,
  });
  final ParentHomeController controller;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final theme = controller.darkMode
          ? ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF70CEC2),
                surface: Color(0xFF193B39),
                onSurface: Color(0xFFEAF5F3),
              ),
              scaffoldBackgroundColor: const Color(0xFF102A29),
            )
          : AppTheme.light.copyWith(
              scaffoldBackgroundColor: ParentHomeTheme.soft,
              textTheme: AppTheme.light.textTheme.apply(
                bodyColor: ParentHomeTheme.ink,
                displayColor: ParentHomeTheme.ink,
              ),
              dividerTheme: const DividerThemeData(
                color: ParentHomeTheme.line,
                thickness: .5,
              ),
            );
      return Theme(
        data: theme,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: theme.colorScheme.onSurface),
          child: ColoredBox(color: theme.scaffoldBackgroundColor, child: child),
        ),
      );
    },
  );
}

class ManagementPage extends StatelessWidget {
  const ManagementPage({
    super.key,
    required this.controller,
    required this.child,
    this.title,
    this.actions = const [],
  });
  final ParentHomeController controller;
  final Widget child;
  final String? title;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => ManagementTheme(
    controller: controller,
    child: Builder(
      builder: (context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: title == null ? null : Text(title!),
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          actions: actions,
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.color = const Color(0xFFCEE7E3),
    this.single = false,
  });
  final String name;
  final double size;
  final Color color;
  final bool single;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size >= 70 ? 24 : size),
    ),
    child: Text(
      single ? initials(name).characters.take(1).toString() : initials(name),
      style: TextStyle(
        fontSize: size * .36,
        fontWeight: FontWeight.w700,
        color: ParentHomeTheme.darkGreen,
      ),
    ),
  );
}

class ManagementCard extends StatelessWidget {
  const ManagementCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: Padding(padding: padding, child: child),
  );
}

class DetailValue extends StatelessWidget {
  const DetailValue(this.label, this.value, {super.key});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ],
    ),
  );
}

class ProfileField extends StatelessWidget {
  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          key: ValueKey(label),
          controller: controller,
          validator: validator ?? requiredValue,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: readOnly
                ? const Icon(Icons.calendar_today_outlined, size: 18)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    ),
  );
}

String? requiredValue(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required.' : null;

void openManagement(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
