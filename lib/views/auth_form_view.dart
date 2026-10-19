import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../models/auth_validators.dart';
import '../theme/app_theme.dart';
import 'auth_views.dart';
import 'otp_view.dart';
import 'widgets/auth_layout.dart';

class AuthFormView extends StatefulWidget {
  const AuthFormView({super.key, required this.controller});
  final AuthController controller;
  @override
  State<AuthFormView> createState() => _AuthFormViewState();
}

class _AuthFormViewState extends State<AuthFormView> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (await widget.controller.sendCode(_phone.text) && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => OtpView(controller: widget.controller),
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
              'Choose a sample Google account. No Google account will be accessed.',
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
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.soft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    c.language,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          footer: TextButton(
            onPressed: () => showPolicy(context),
            child: const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, color: AppTheme.muted),
                children: [
                  TextSpan(text: 'By continuing you agree to our '),
                  TextSpan(
                    text: 'Terms',
                    style: TextStyle(
                      color: AppTheme.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: TextStyle(
                      color: AppTheme.teal,
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
              'Enter your mobile number',
              'We’ll send you a 6-digit code to sign in or create your account.',
            ),
            const Text(
              'Mobile number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 6),
            Form(
              key: _form,
              child: TextFormField(
                controller: _phone,
                enabled: !c.busy,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: AuthValidators.phone,
                onFieldSubmitted: (_) {
                  if (!c.busy) _send();
                },
                decoration: const InputDecoration(
                  hintText: '77 123 4567',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'LK +94',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ink,
                      ),
                    ),
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
                  Expanded(child: Divider(color: AppTheme.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider(color: AppTheme.line)),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: c.busy ? null : _google,
              icon: const Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
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
