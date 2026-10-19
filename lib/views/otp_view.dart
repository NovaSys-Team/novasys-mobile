import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import 'auth_views.dart';
import 'registration_view.dart';
import 'widgets/auth_layout.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key, required this.controller});
  final AuthController controller;
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
          builder: (_) => RegistrationView(controller: widget.controller),
        ),
      );
    }
  }

  Future<void> _verify() async {
    if (await widget.controller.verify(_code.text)) _next();
  }

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
      return PopScope(
        canPop: !c.busy,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) c.cancelVerification();
        },
        child: AuthLayout(
          header: BackHeader(onBack: c.busy ? null : _back),
          footer: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PROTOTYPE SHORTCUTS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('New number → ', style: TextStyle(fontSize: 12)),
                    TextButton(
                      onPressed: c.busy ? null : () => _shortcut(null),
                      child: const Text('Create account'),
                    ),
                    const Text('Existing ', style: TextStyle(fontSize: 12)),
                    TextButton(
                      onPressed: c.busy
                          ? null
                          : () => _shortcut(UserRole.parent),
                      child: const Text('parent'),
                    ),
                    TextButton(
                      onPressed: c.busy
                          ? null
                          : () => _shortcut(UserRole.driver),
                      child: const Text('driver'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            Text(
              'Enter the code',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Sent by SMS to ${c.displayPhone}'),
                TextButton(
                  onPressed: c.busy ? null : _back,
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              enabled: !c.busy,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                hintText: '------',
                semanticCounterText: '6 digit verification code',
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (_code.text.length == 6 && !c.busy) _verify();
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Type any 6 digits for the demo',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            ErrorMessage(c.error),
            const SizedBox(height: 24),
            ActionButton(
              label: 'Verify',
              busy: c.busy,
              onPressed: _code.text.length == 6 ? _verify : null,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Didn’t get it? '),
                TextButton(
                  onPressed: c.busy || c.resendSeconds > 0
                      ? null
                      : () async {
                          if (await c.resendCode()) _code.clear();
                        },
                  child: Text(
                    c.resendSeconds > 0
                        ? 'Resend in 0:${c.resendSeconds.toString().padLeft(2, '0')}'
                        : 'Resend code',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
