import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../models/parent_models.dart';
import '../../models/auth_validators.dart';
import 'widgets/management_widgets.dart';

class ParentProfileFormView extends StatefulWidget {
  const ParentProfileFormView({super.key, required this.controller});
  final ParentHomeController controller;
  @override
  State<ParentProfileFormView> createState() => _ParentProfileFormViewState();
}

class _ParentProfileFormViewState extends State<ParentProfileFormView> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name, _phone, _email;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.controller.profile.name);
    _phone = TextEditingController(text: widget.controller.profile.phone);
    _email = TextEditingController(text: widget.controller.profile.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    widget.controller.updateProfile(
      ParentProfile(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ManagementPage(
    controller: widget.controller,
    title: 'Edit parent profile',
    actions: [TextButton(onPressed: _save, child: const Text('Save'))],
    child: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ProfileAvatar(
              name: widget.controller.profile.name,
              size: 72,
            ),
          ),
          const SizedBox(height: 24),
          ProfileField(
            label: 'Full name',
            controller: _name,
            validator: AuthValidators.name,
          ),
          ProfileField(
            label: 'Mobile number',
            controller: _phone,
            keyboardType: TextInputType.phone,
            validator: AuthValidators.optionalPhone,
          ),
          ProfileField(
            label: 'Email address',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.requiredEmail,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ),
  );
}
