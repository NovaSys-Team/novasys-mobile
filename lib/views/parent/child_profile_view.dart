import 'package:flutter/material.dart';

import '../../controllers/parent_home_controller.dart';
import '../../models/parent_models.dart';
import '../../theme/parent_home_theme.dart';
import 'child_form_view.dart';
import 'widgets/management_widgets.dart';

class ChildProfileView extends StatefulWidget {
  const ChildProfileView({
    super.key,
    required this.controller,
    required this.childId,
  });
  final ParentHomeController controller;
  final String childId;
  @override
  State<ChildProfileView> createState() => _ChildProfileViewState();
}

class _ChildProfileViewState extends State<ChildProfileView> {
  bool _showPin = true;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final child = widget.controller.childById(widget.childId);
      return ManagementPage(
        controller: widget.controller,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(60, 40)),
              onPressed: () => openManagement(
                context,
                ChildFormView(controller: widget.controller, childId: child.id),
              ),
              child: const Text('Edit'),
            ),
          ),
        ],
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Builder(
                builder: (context) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: ChildIdentity(child: child),
                      ),
                      const TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(text: 'Details'),
                          Tab(text: 'Health'),
                          Tab(text: 'Pickup people'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        DetailValue('Full name', child.name),
                        DetailValue(
                          'Date of birth',
                          birthDate(child.dateOfBirth),
                        ),
                        DetailValue('School', child.school),
                        DetailValue(
                          'Grade & class',
                          '${child.grade} \u00b7 ${child.className}',
                        ),
                        DetailValue('Pickup & drop-off point', child.address),
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ParentHomeTheme.mint,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Only ${child.name.split(' ').first}\u2019s driver and NovaSys admins can see this.',
                            style: const TextStyle(
                              color: ParentHomeTheme.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DetailValue('Allergies', child.allergies),
                        DetailValue('Medical notes', child.medicalNotes),
                        DetailValue(
                          'Emergency contact',
                          child.emergencyContact,
                        ),
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ParentHomeTheme.darkGreen,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'HOME HANDOVER PIN',
                                      style: TextStyle(
                                        color: Color(0xFFA9D9D2),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _showPin
                                          ? child.handoverPin
                                          : '\u2022\u2022\u2022\u2022',
                                      key: const ValueKey('handover-pin'),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF315B59),
                                ),
                                onPressed: () =>
                                    setState(() => _showPin = !_showPin),
                                child: Text(_showPin ? 'Hide' : 'Show'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Who can pick up ${child.name.split(' ').first}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (child.pickupPeople.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text('No authorized pickup people yet.'),
                          ),
                        for (var i = 0; i < child.pickupPeople.length; i++) ...[
                          ManagementCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                ProfileAvatar(
                                  name: child.pickupPeople[i].name,
                                  color: [
                                    const Color(0xFFCEE7E3),
                                    const Color(0xFFE5DFF5),
                                    const Color(0xFFFFD2C3),
                                  ][i % 3],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child.pickupPeople[i].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${child.pickupPeople[i].relationship}${child.pickupPeople[i].needsPin ? ' \u00b7 needs PIN' : ''}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        OutlinedButton(
                          onPressed: () => _addPerson(context),
                          child: const Text('+ Add a person'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future<void> _addPerson(BuildContext context) async {
    final person = await showDialog<PickupPerson>(
      context: context,
      builder: (_) => const _PickupPersonDialog(),
    );
    if (person != null && mounted) {
      widget.controller.addPickupPerson(widget.childId, person);
    }
  }
}

class ChildIdentity extends StatelessWidget {
  const ChildIdentity({super.key, required this.child});
  final Child child;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ProfileAvatar(
        name: child.name,
        size: 72,
        single: true,
        color: const Color(0xFFFFD2C3),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              child.name,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            Text(
              '${child.grade} \u00b7 ${child.school}',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PickupPersonDialog extends StatefulWidget {
  const _PickupPersonDialog();
  @override
  State<_PickupPersonDialog> createState() => _PickupPersonDialogState();
}

class _PickupPersonDialogState extends State<_PickupPersonDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _relationship = TextEditingController();
  bool _needsPin = true;
  @override
  void dispose() {
    _name.dispose();
    _relationship.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add a person'),
    content: SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileField(label: 'Full name', controller: _name),
            ProfileField(label: 'Relationship', controller: _relationship),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Needs handover PIN'),
              value: _needsPin,
              onChanged: (value) => setState(() => _needsPin = value),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(
              context,
              PickupPerson(
                name: _name.text.trim(),
                relationship: _relationship.text.trim(),
                needsPin: _needsPin,
              ),
            );
          }
        },
        child: const Text('Add'),
      ),
    ],
  );
}
