import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/auth_validators.dart';
import '../theme/auth_theme.dart';
import 'auth_views.dart';
import 'widgets/auth_layout.dart';
import 'widgets/auth_details.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key, required this.controller});
  final AuthController controller;
  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  bool _consent = false;
  bool _photo = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (await widget.controller.register(
          name: _name.text,
          email: _email.text,
          consent: _consent,
          hasPhoto: _photo,
        ) &&
        mounted) {
      openDashboard(context, widget.controller);
    }
  }

  Future<void> _choosePhoto() async {
    final choice = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Profile photo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text('Use a sample avatar for this local demo.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Use demo photo'),
              ),
              if (_photo)
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Remove photo'),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice != null && mounted) setState(() => _photo = choice);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      return PopScope(
        canPop: !c.busy,
        child: AuthLayout(
          headerSpacing: 12,
          header: BackHeader(
            onBack: c.busy
                ? null
                : () {
                    Navigator.pop(context);
                  },
            title: 'Create your account',
          ),
          footer: ActionButton(
            label: 'Create ${c.role.name} account',
            busy: c.busy,
            onPressed: _submit,
          ),
          children: [
            InkWell(
              onTap: c.busy ? null : _choosePhoto,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ProfilePhotoPlaceholder(hasPhoto: _photo),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AuthTheme.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile photo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AuthTheme.ink,
                          ),
                        ),
                        Text(
                          'Helps drivers and parents recognise you',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AuthTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _name,
                    enabled: !c.busy,
                    validator: AuthValidators.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    decoration: const InputDecoration(
                      hintText: 'Your full name',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Email (optional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AuthTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _email,
                    enabled: !c.busy,
                    validator: AuthValidators.email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuthTheme.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.displayPhone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AuthTheme.ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.check, size: 16, color: AuthTheme.verified),
                  const Text(
                    ' Verified',
                    style: TextStyle(fontSize: 12, color: AuthTheme.verified),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 32,
                  child: Checkbox(
                    value: _consent,
                    onChanged: c.busy
                        ? null
                        : (value) => setState(() => _consent = value!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () => showPolicy(context),
                    child: const Text(
                      'I agree to the Terms & Conditions and Privacy Policy',
                      style: TextStyle(fontSize: 13, color: AuthTheme.muted),
                    ),
                  ),
                ),
              ],
            ),
            ErrorMessage(c.error),
          ],
        ),
      );
    },
  );
}
