import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../models/parent_models.dart';
import 'child_profile_view.dart';
import 'widgets/management_widgets.dart';

class ChildFormView extends StatefulWidget {
  const ChildFormView({super.key, required this.controller, this.childId});
  final ParentHomeController controller;
  final String? childId;
  @override
  State<ChildFormView> createState() => _ChildFormViewState();
}

class _ChildFormViewState extends State<ChildFormView> {
  final _form = GlobalKey<FormState>();
  late final Child? _original;
  late final TextEditingController _name,
      _dobText,
      _school,
      _grade,
      _className,
      _address;
  DateTime? _dob;
  @override
  void initState() {
    super.initState();
    _original = widget.childId == null
        ? null
        : widget.controller.childById(widget.childId!);
    _dob = _original?.dateOfBirth;
    _name = TextEditingController(text: _original?.name);
    _dobText = TextEditingController(text: _dob == null ? '' : birthDate(_dob));
    _school = TextEditingController(text: _original?.school);
    _grade = TextEditingController(text: _original?.grade);
    _className = TextEditingController(text: _original?.className);
    _address = TextEditingController(text: _original?.address);
  }

  @override
  void dispose() {
    for (final field in [
      _name,
      _dobText,
      _school,
      _grade,
      _className,
      _address,
    ]) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final result = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 8, now.month, now.day),
      firstDate: DateTime(now.year - 25),
      lastDate: now,
      helpText: 'Child date of birth',
    );
    if (result != null && mounted) {
      setState(() {
        _dob = result;
        _dobText.text = birthDate(result);
      });
    }
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final child = (_original ?? const Child(id: '', name: '', school: ''))
        .copyWith(
          name: _name.text.trim(),
          dateOfBirth: _dob,
          school: _school.text.trim(),
          grade: _grade.text.trim(),
          className: _className.text.trim(),
          address: _address.text.trim(),
        );
    widget.controller.saveChild(child, isNew: _original == null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ManagementPage(
    controller: widget.controller,
    title: _original == null ? 'Add child' : null,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(65, 40)),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ),
    ],
    child: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_original != null) ...[
            ChildIdentity(child: _original),
            const SizedBox(height: 24),
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const Divider(),
            const SizedBox(height: 8),
          ],
          ProfileField(label: 'Full name', controller: _name),
          ProfileField(
            label: 'Date of birth',
            controller: _dobText,
            readOnly: true,
            onTap: _pickDate,
          ),
          ProfileField(label: 'School', controller: _school),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileField(label: 'Grade', controller: _grade),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileField(label: 'Class', controller: _className),
              ),
            ],
          ),
          ProfileField(
            label: 'Pickup & drop-off point',
            controller: _address,
            maxLines: 2,
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
