import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../models/auth_validators.dart';
import '../theme/auth_theme.dart';
import 'auth_views.dart';
import 'otp_view.dart';
import 'widgets/auth_layout.dart';

/// P02 — Sign in or create account with an email address.
class AuthFormView extends StatefulWidget {
  const AuthFormView({
    super.key,
    required this.controller,
    this.roleSelected = false,
  });
  final AuthController controller;
  final bool roleSelected;
  @override
  State<AuthFormView> createState() => _AuthFormViewState();
}

class _AuthFormViewState extends State<AuthFormView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = widget.controller.email;
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (await widget.controller.sendCode(_email.text) && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => OtpView(
            controller: widget.controller,
            roleSelected: widget.roleSelected,
          ),
        ),
      );
    }
  }

  Future<void> _google() async {
    final role = await showDialog<UserRole>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Google sign-in demo'),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Google OAuth is not wired up yet. Choose a sample account to '
              'continue; no Google account will be accessed.',
            ),
          ),
          for (final role in UserRole.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, role),
              child: Text('${role.label} demo'),
            ),
        ],
      ),
    );
    if (role != null && await widget.controller.googleDemo(role) && mounted) {
      openDashboard(context, widget.controller);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      return PopScope(
        canPop: !c.busy,
        child: AuthLayout(
          header: BackHeader(
            onBack: c.busy ? null : () => Navigator.pop(context),
          ),
          footer: TextButton(
            onPressed: () => showPolicy(context),
            child: const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, color: AuthTheme.muted),
                children: [
                  TextSpan(text: 'By continuing you agree to our '),
                  TextSpan(
                    text: 'Terms',
                    style: TextStyle(
                      color: AuthTheme.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: TextStyle(
                      color: AuthTheme.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          children: [
            const AuthHeading(
              'Sign in or create account',
              'We’ll email you a 6-digit code to sign in. New here? Enter '
                  'your email to create a new account.',
            ),
            const Text(
              'Email address',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AuthTheme.ink,
              ),
            ),
            const SizedBox(height: 6),
            Form(
              key: _form,
              child: TextFormField(
                controller: _email,
                enabled: !c.busy,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  LengthLimitingTextInputFormatter(120),
                ],
                validator: AuthValidators.requiredEmail,
                onFieldSubmitted: (_) {
                  if (!c.busy) _send();
                },
                style: const TextStyle(fontSize: 16, color: AuthTheme.ink),
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 18, right: 14),
                    child: Icon(
                      Icons.mail_outline,
                      size: 20,
                      color: AuthTheme.teal,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: AuthTheme.teal, width: 1.6),
                  ),
                ),
              ),
            ),
            ErrorMessage(c.error),
            const SizedBox(height: 24),
            ActionButton(label: 'Send code', busy: c.busy, onPressed: _send),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  Expanded(child: Divider(color: AuthTheme.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider(color: AuthTheme.line)),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: c.busy ? null : _google,
              icon: SvgPicture.string(
                _googleMark,
                width: 20,
                height: 20,
                excludeFromSemantics: true,
              ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Individual 20px Google mark from the latest export; never a screen image.
const _googleMark = r'''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 3.95833C11.4583 3.95833 12.75 4.45833 13.75 5.41667L16.5417 2.625C14.8333 1.04167 12.5833 0 10 0C6.08333 0 2.75 2.25 1.125 5.5L4.375 8.04167C5.16667 5.66667 7.375 3.95833 10 3.95833Z" fill="#EA4335"/>
<path d="M19.375 10.2083C19.375 9.54165 19.3333 8.91665 19.2083 8.33331H10V12.0833H15.2917C15.0417 13.3333 14.3333 14.375 13.2917 15.0833L16.4583 17.5416C18.2917 15.8333 19.375 13.3333 19.375 10.2083Z" fill="#4285F4"/>
<path d="M4.375 11.9583C4.16667 11.3333 4.04167 10.7083 4.04167 10C4.04167 9.29167 4.16667 8.66667 4.375 8.04167L1.125 5.5C0.416667 6.91667 0 8.41667 0 10C0 11.5833 0.416667 13.0833 1.125 14.5L4.375 11.9583Z" fill="#FBBC05"/>
<path d="M10 20C12.7083 20 14.9583 19.125 16.625 17.5833L13.4583 15.125C12.5833 15.7083 11.4167 16.0833 10 16.0833C7.375 16.0833 5.16667 14.375 4.375 12L1.125 14.5417C2.75 17.75 6.08333 20 10 20Z" fill="#34A853"/>
</svg>''';
