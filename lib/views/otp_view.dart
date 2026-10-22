import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../theme/auth_theme.dart';
import 'auth_views.dart';
import 'registration_view.dart';
import 'role_selection_view.dart';
import 'widgets/auth_details.dart';
import 'widgets/auth_layout.dart';
import 'widgets/otp_boxes.dart';

/// P02B — Check your email: six-box code entry for the address just entered.
class OtpView extends StatefulWidget {
  const OtpView({
    super.key,
    required this.controller,
    this.roleSelected = false,
  });
  final AuthController controller;
  final bool roleSelected;
  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final _code = TextEditingController();
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _next() {
    if (!mounted) return;
    if (widget.controller.user != null) {
      openDashboard(context, widget.controller);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => widget.roleSelected
              ? RegistrationView(controller: widget.controller)
              : RoleSelectionView(
                  controller: widget.controller,
                  identityVerified: true,
                ),
        ),
      );
    }
  }

  Future<void> _verify() async {
    if (await widget.controller.verify(_code.text)) _next();
  }

  /// Prototype only: accepts a sample identity without contacting anything.
  Future<void> _shortcut(UserRole? role) async {
    if (await widget.controller.shortcut(role)) _next();
  }

  void _back() {
    widget.controller.cancelVerification();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      final complete = _code.text.length == 6;
      return PopScope(
        canPop: !c.busy,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) c.cancelVerification();
        },
        child: AuthLayout(
          headerSpacing: 20,
          header: BackHeader(onBack: c.busy ? null : _back),
          footer: _ShortcutCard(busy: c.busy, onShortcut: _shortcut),
          children: [
            const MailBadge(),
            const SizedBox(height: 20),
            const AuthTitle('Check your email'),
            const SizedBox(height: 10),
            const Text('We sent a 6-digit code to'),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${c.displayEmail}.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AuthTheme.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: c.busy ? null : _back,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Change email'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Verification code',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AuthTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            OtpBoxes(
              controller: _code,
              enabled: !c.busy,
              onChanged: (_) => setState(() {}),
              onSubmitted: () {
                if (complete && !c.busy) _verify();
              },
            ),
            const SizedBox(height: 10),
            Text(
              complete
                  ? 'Code complete · tap Verify'
                  : 'Enter the 6-digit code from your email',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: complete ? AuthTheme.teal : AuthTheme.muted,
              ),
            ),
            ErrorMessage(c.error),
            const SizedBox(height: 20),
            ActionButton(
              label: 'Verify & continue',
              busy: c.busy,
              onPressed: complete ? _verify : null,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Didn’t get the email?'),
                TextButton(
                  onPressed: c.busy || c.resendSeconds > 0
                      ? null
                      : () async {
                          if (await c.resendCode()) {
                            _code.clear();
                            if (mounted) setState(() {});
                          }
                        },
                  child: Text(
                    c.resendSeconds > 0
                        ? 'Resend in ${c.resendLabel}'
                        : 'Resend code',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const _InfoCard(),
          ],
        ),
      );
    },
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AuthTheme.soft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18, color: AuthTheme.slate),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Can’t find it? Check your spam folder. The code expires in 10 '
            'minutes.',
            style: TextStyle(fontSize: 13, height: 1.4, color: AuthTheme.slate),
          ),
        ),
      ],
    ),
  );
}

/// Names the simulated behaviour outright so nobody mistakes this build for a
/// working email sign-in, and offers the two sample identities as shortcuts.
class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.busy, required this.onShortcut});
  final bool busy;
  final Future<void> Function(UserRole?) onShortcut;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AuthTheme.soft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PROTOTYPE SHORTCUTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
            color: AuthTheme.slate,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'No email is sent — any 6 digits unlock verify.',
          style: TextStyle(fontSize: 13, height: 1.4, color: AuthTheme.slate),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'New email →',
              style: TextStyle(fontSize: 13, color: AuthTheme.slate),
            ),
            TextButton(
              onPressed: busy ? null : () => onShortcut(null),
              style: _linkStyle,
              child: const Text('Create account'),
            ),
            const Text(
              '·',
              style: TextStyle(fontSize: 13, color: AuthTheme.slate),
            ),
            TextButton(
              onPressed: busy ? null : () => onShortcut(UserRole.parent),
              style: _linkStyle,
              child: const Text('Existing parent'),
            ),
          ],
        ),
      ],
    ),
  );

  static final _linkStyle = TextButton.styleFrom(
    minimumSize: const Size(48, 36),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    ),
  );
}
