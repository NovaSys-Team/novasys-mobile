import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/controllers/parent_home_controller.dart';
import 'package:novasys_mobile/controllers/auth_controller.dart';
import 'package:novasys_mobile/models/app_user.dart';
import 'package:novasys_mobile/repositories/auth_repository.dart';
import 'package:novasys_mobile/views/auth_views.dart';
import 'package:novasys_mobile/views/entry_views.dart';
import 'package:novasys_mobile/models/parent_models.dart';
import 'package:novasys_mobile/theme/app_theme.dart';
import 'package:novasys_mobile/views/parent/parent_home_shell.dart';
import 'package:novasys_mobile/views/parent/parent_preview.dart';
import 'package:novasys_mobile/views/parent/parent_home_view.dart';
import 'package:novasys_mobile/views/parent/new_parent_home_view.dart';
import 'package:novasys_mobile/views/parent/widgets/parent_bottom_nav.dart';
import 'package:novasys_mobile/views/parent/widgets/management_widgets.dart';
import 'package:novasys_mobile/views/parent/child_profile_view.dart';
import 'package:novasys_mobile/views/parent/child_form_view.dart';
import 'package:novasys_mobile/views/parent/parent_profile_form_view.dart';

Future<void> tapText(WidgetTester t, String text) async {
  final target = find.text(text);
  if (target.evaluate().isEmpty) {
    await t.scrollUntilVisible(
      target,
      180,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await t.ensureVisible(target.last);
  await t.pumpAndSettle();
  await t.tap(target.last);
  await t.pumpAndSettle();
}

Future<void> back(WidgetTester t) async {
  await t.tap(find.byTooltip('Back'));
  await t.pumpAndSettle();
}

Future<void> field(WidgetTester t, String label, String value) async {
  final target = find.byKey(ValueKey(label));
  if (target.evaluate().isEmpty) {
    await t.scrollUntilVisible(
      target,
      180,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await t.ensureVisible(target);
  await t.enterText(target, value);
  await t.pumpAndSettle();
}

Future<ParentHomeController> launch(
  WidgetTester t, {
  Size size = const Size(390, 844),
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  final c = ParentHomeController();
  addTearDown(c.dispose);
  if (size.width < 360) c.selectNavTab(4);
  await t.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: ParentHomeShell(controller: c),
    ),
  );
  await tapText(t, 'Account');
  return c;
}

void main() {
  testWidgets(
    'signed-in parent profile reaches Account and sign-out returns to welcome',
    (t) async {
      final auth = AuthController(DemoAuthRepository());
      addTearDown(auth.dispose);
      await t.runAsync(() => auth.googleDemo(UserRole.parent));
      final signedInName = auth.user!.name;
      await t.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => openDashboard(context, auth),
                child: const Text('Open dashboard'),
              ),
            ),
          ),
        ),
      );
      await tapText(t, 'Open dashboard');
      await tapText(t, 'Account');
      expect(find.text(signedInName), findsOneWidget);
      await tapText(t, 'Sign out');
      await tapText(t, 'Cancel');
      expect(auth.user, isNotNull);
      await tapText(t, 'Sign out');
      await tapText(t, 'Sign out');
      expect(auth.user, isNull);
      expect(find.byType(InitialView), findsOneWidget);
      expect(find.byType(ParentHomePreview), findsNothing);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'child edit saves to profile, Account and Home; cancel discards',
    (t) async {
      final c = await launch(t);
      await tapText(t, 'Sanuli Perera');
      expect(find.byType(ChildProfileView), findsOneWidget);
      await tapText(t, 'Edit');
      await field(t, 'Full name', 'Sanuli Fernando');
      await field(t, 'School', 'Gateway College');
      await field(t, 'Grade', 'Grade 6');
      await tapText(t, 'Save');
      expect(find.text('Sanuli Fernando'), findsNWidgets(2));
      expect(find.text('Gateway College'), findsOneWidget);
      expect(c.selectedChild.hasTransport, isTrue);
      expect(c.selectedTransport, isNotNull);
      await tapText(t, 'Edit');
      await field(t, 'Full name', 'Discarded');
      await back(t);
      expect(find.text('Discarded'), findsNothing);
      await back(t);
      expect(find.text('Sanuli Fernando'), findsOneWidget);
      await tapText(t, 'Home');
      expect(find.byType(ParentHomeView), findsOneWidget);
      expect(find.text('Sanuli Fernando'), findsWidgets);
      expect(find.byType(ParentBottomNav), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('Add child validates, selects DOB, and shares child with Home', (
    t,
  ) async {
    final c = await launch(t);
    await tapText(t, '+ Add child');
    await tapText(t, 'Save');
    expect(find.text('This field is required.'), findsWidgets);
    expect(c.children, hasLength(2));
    await field(t, 'Full name', 'Amaya Silva');
    await t.tap(find.byKey(const ValueKey('Date of birth')));
    await t.pumpAndSettle();
    await tapText(t, '10');
    await tapText(t, 'OK');
    await field(t, 'School', 'Ladies College');
    await field(t, 'Grade', 'Grade 3');
    await field(t, 'Class', 'C');
    await field(t, 'Pickup & drop-off point', '18 Flower Road, Colombo');
    await tapText(t, 'Save');
    expect(c.children, hasLength(3));
    expect(c.children.last.dateOfBirth, isNotNull);
    expect(find.text('Amaya Silva'), findsOneWidget);
    await tapText(t, 'Amaya Silva');
    expect(find.text('18 Flower Road, Colombo'), findsOneWidget);
    await back(t);
    await tapText(t, 'Home');
    expect(c.selectedChild.name, 'Amaya Silva');
    expect(c.selectedTransport, isNull);
    expect(t.takeException(), isNull);
  });

  testWidgets('health, PIN hide/show and authorized pickup person persist', (
    t,
  ) async {
    final c = await launch(t);
    await tapText(t, 'Sanuli Perera');
    await tapText(t, 'Health');
    expect(find.text('Peanuts (severe)'), findsOneWidget);
    await tapText(t, 'Pickup people');
    expect(find.text('4279'), findsOneWidget);
    await tapText(t, 'Hide');
    expect(find.text('4279'), findsNothing);
    await tapText(t, 'Show');
    expect(find.text('4279'), findsOneWidget);
    await tapText(t, '+ Add a person');
    await tapText(t, 'Add');
    expect(find.text('This field is required.'), findsNWidgets(2));
    await field(t, 'Full name', 'Nimal Silva');
    await field(t, 'Relationship', 'Uncle');
    await tapText(t, 'Add');
    expect(find.text('Nimal Silva'), findsOneWidget);
    expect(c.childById('1').pickupPeople.last.needsPin, isTrue);
    await back(t);
    await tapText(t, 'Sanuli Perera');
    await tapText(t, 'Pickup people');
    expect(find.text('Nimal Silva'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('parent form validates contact, saves, and cancels', (t) async {
    final c = await launch(t);
    await tapText(t, 'Edit');
    await field(t, 'Mobile number', '123');
    await field(t, 'Email address', 'invalid');
    await tapText(t, 'Save');
    expect(find.byType(ParentProfileFormView), findsOneWidget);
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    await field(t, 'Full name', 'Vishmi Perera');
    await field(t, 'Mobile number', '0779876543');
    await field(t, 'Email address', 'vishmi@example.com');
    await tapText(t, 'Save');
    expect(find.text('Vishmi Perera'), findsOneWidget);
    expect(c.profile.email, 'vishmi@example.com');
    await tapText(t, 'Edit');
    await field(t, 'Full name', 'Discarded');
    await tapText(t, 'Cancel');
    expect(c.profile.name, 'Vishmi Perera');
    expect(t.takeException(), isNull);
  });

  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('Account, dark theme, notifications and forms fit $size', (
      t,
    ) async {
      final c = await launch(t, size: size);
      await tapText(t, 'Dark');
      expect(c.darkMode, isTrue);
      final cardContext = t.element(find.byType(ManagementCard).first);
      expect(Theme.of(cardContext).brightness, Brightness.dark);
      await tapText(t, 'Notifications');
      await t.tap(find.byType(SwitchListTile).first);
      await t.pumpAndSettle();
      expect(c.pushNotifications, isFalse);
      await tapText(t, 'Done');
      await t.drag(find.byType(ListView).first, const Offset(0, 1000));
      await t.pumpAndSettle();
      await tapText(t, '+ Add child');
      t.view.viewInsets = const FakeViewPadding(bottom: 250);
      await t.pumpAndSettle();
      await field(t, 'Pickup & drop-off point', 'New address');
      expect(find.byType(ChildFormView), findsOneWidget);
      expect(t.takeException(), isNull);
      t.view.resetViewInsets();
      await back(t);
      expect(find.byType(ParentBottomNav), findsOneWidget);
    });
  }

  testWidgets('P03/P03A toggle retains one controller and local edits', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const ParentHomePreview(
          profile: ParentProfile(
            name: 'Signed In Parent',
            phone: '',
            email: 'parent@example.com',
          ),
        ),
      ),
    );
    final c = t
        .widget<ParentHomeShell>(find.byType(ParentHomeShell))
        .controller;
    c.updateProfile(
      const ParentProfile(
        name: 'Edited Parent',
        phone: '',
        email: 'parent@example.com',
      ),
    );
    await tapText(t, 'P03');
    expect(find.byType(NewParentHomeView), findsOneWidget);
    await tapText(t, 'Account');
    expect(find.text('Edited Parent'), findsOneWidget);
    await tapText(t, 'Home');
    await tapText(t, 'P03A');
    expect(find.byType(ParentHomeView), findsOneWidget);
    expect(
      identical(
        c,
        t.widget<ParentHomeShell>(find.byType(ParentHomeShell)).controller,
      ),
      isTrue,
    );
    expect(t.takeException(), isNull);
  });
}
