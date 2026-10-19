import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.headerSpacing = 24,
  });
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final double headerSpacing;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (header != null) ...[
                          header!,
                          SizedBox(height: headerSpacing),
                        ],
                        ...children,
                        if (footer != null) ...[
                          const SizedBox(height: 24),
                          const Spacer(),
                          footer!,
                        ],
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

class BackHeader extends StatelessWidget {
  const BackHeader({super.key, this.onBack, this.title, this.trailing});
  final VoidCallback? onBack;
  final String? title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton.outlined(
        onPressed: onBack,
        tooltip: 'Back',
        style: IconButton.styleFrom(
          side: const BorderSide(color: AppTheme.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        icon: const Icon(Icons.chevron_left),
      ),
      if (title != null) ...[
        const SizedBox(width: 12),
        Expanded(
          child: Text(title!, style: Theme.of(context).textTheme.titleLarge),
        ),
      ] else
        const Spacer(),
      ?trailing,
    ],
  );
}

class AuthHeading extends StatelessWidget {
  const AuthHeading(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: AppTheme.muted,
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.busy,
    this.onPressed,
  });
  final String label;
  final bool busy;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              semanticsLabel: 'Please wait',
            ),
          )
        : Text(label),
  );
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.message, {super.key});
  final String? message;
  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Semantics(
            liveRegion: true,
            child: Text(
              message!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
}

void showPolicy(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Terms & Privacy Policy'),
    content: const Text(
      'NovaSys demo\n\nUse sample information only. Account details stay in memory until the app restarts. No SMS is sent and no Google account is accessed. This preview does not book or track transport.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  ),
);
