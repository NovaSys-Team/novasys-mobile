import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/main.dart';
import 'package:novasys_mobile/views/entry_views.dart';
import 'package:novasys_mobile/views/auth_views.dart';
import 'package:novasys_mobile/views/role_selection_view.dart';
import 'package:novasys_mobile/views/registration_view.dart';

Future<void> tap(WidgetTester t, String text) async {
  final f = find.text(text);
  await Scrollable.ensureVisible(t.element(f), alignment: .5);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

Future<void> launch(WidgetTester t) async {
  await t.pumpWidget(const NovaSysApp());
  expect(find.byType(SplashView), findsOneWidget);
  await t.pump(const Duration(milliseconds: 1400));
  await t.pumpAndSettle();
  expect(find.byType(InitialView), findsOneWidget);
}

Future<void> signIn(WidgetTester t, String phone) async {
  await launch(t);
  await tap(t, 'Sign In');
  await t.enterText(find.byType(TextFormField), phone);
  await tap(t, 'Send code');
}

Future<void> signup(WidgetTester t, String role) async {
  await launch(t);
  await tap(t, 'Create an Account');
  expect(find.byType(WelcomeView), findsOneWidget);
  await tap(t, 'Continue');
  expect(find.byType(RoleSelectionView), findsOneWidget);
  await tap(t, role);
  await tap(t, 'Continue');
  await t.enterText(find.byType(TextFormField), '779999999');
  await tap(t, 'Send code');
  await t.enterText(find.byType(TextField), '123456');
  await tap(t, 'Verify');
  expect(find.byType(RegistrationView), findsOneWidget);
}

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;
  for (final role in ['Parent', 'Driver']) {
    testWidgets(
      '$role complete signup flow, validation, photo, and dashboard',
      (t) async {
        await signup(t, role);
        expect(find.text('I am a'), findsNothing);
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.text('Enter your full name.'), findsOneWidget);
        await t.enterText(find.byType(TextFormField).first, 'New $role');
        await t.enterText(find.byType(TextFormField).last, 'invalid');
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.text('Enter a valid email address.'), findsOneWidget);
        await t.enterText(find.byType(TextFormField).last, '');
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.textContaining('Agree to the Terms'), findsOneWidget);
        await tap(t, 'Profile photo');
        await tap(t, 'Use demo photo');
        await t.ensureVisible(find.byType(Checkbox));
        await t.tap(find.byType(Checkbox));
        await t.pumpAndSettle();
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.text('$role dashboard'), findsOneWidget);
        await tap(t, 'Sign out');
        expect(find.byType(WelcomeView), findsOneWidget);
      },
    );
  }
  for (final entry in [('771234567', 'Parent'), ('772345678', 'Driver')]) {
    testWidgets('${entry.$2} existing account bypasses registration', (
      t,
    ) async {
      await signIn(t, entry.$1);
      await t.enterText(find.byType(TextField), '123456');
      await tap(t, 'Verify');
      expect(find.text('${entry.$2} dashboard'), findsOneWidget);
    });
  }
  testWidgets('new number via sign in selects role after verification', (
    t,
  ) async {
    await signIn(t, '779999999');
    await t.enterText(find.byType(TextField), '123456');
    await tap(t, 'Verify');
    expect(find.byType(RoleSelectionView), findsOneWidget);
    await tap(t, 'Driver');
    await tap(t, 'Continue');
    expect(find.text('Create driver account'), findsOneWidget);
    await t.ensureVisible(find.byTooltip('Back'));
    await t.tap(find.byTooltip('Back'));
    await t.pumpAndSettle();
    await tap(t, 'Parent');
    await tap(t, 'Continue');
    await t.enterText(find.byType(TextFormField).first, 'Demo Parent');
    await t.ensureVisible(find.byType(Checkbox));
    await t.tap(find.byType(Checkbox));
    await t.pumpAndSettle();
    await tap(t, 'Create parent account');
    expect(find.text('Parent dashboard'), findsOneWidget);
  });
  testWidgets('mobile validation, OTP gating, resend and change phone', (
    t,
  ) async {
    await launch(t);
    await tap(t, 'Sign In');
    await tap(t, 'Send code');
    expect(find.textContaining('Enter a valid 9-digit'), findsOneWidget);
    await t.enterText(find.byType(TextFormField), '771234567');
    await tap(t, 'Send code');
    await t.enterText(find.byType(TextField), '1234');
    await t.pump();
    expect(
      t
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Verify'))
          .onPressed,
      isNull,
    );
    await t.pump(const Duration(seconds: 31));
    await t.pumpAndSettle();
    await tap(t, 'Resend code');
    expect(find.textContaining('Resend in'), findsOneWidget);
    await tap(t, 'Change');
    expect(find.text('Enter your mobile number'), findsOneWidget);
  });
  testWidgets('Google remains an explicit simulation', (t) async {
    await launch(t);
    await tap(t, 'Sign In');
    await tap(t, 'Continue with Google');
    expect(find.text('Google sign-in demo'), findsOneWidget);
    await tap(t, 'Driver demo');
    expect(find.text('Driver dashboard'), findsOneWidget);
  });
  testWidgets(
    'small screen, language, back navigation and registration keyboard',
    (t) async {
      t.view.physicalSize = const Size(320, 640);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.view.resetViewInsets);
      await launch(t);
      await tap(t, 'Create an Account');
      await tap(t, 'සිංහල');
      await tap(t, 'Continue');
      await tap(t, 'Driver');
      await t.ensureVisible(find.byTooltip('Back'));
      await t.tap(find.byTooltip('Back'));
      await t.pumpAndSettle();
      await tap(t, 'Continue');
      await tap(t, 'Continue');
      expect(find.text('Sinhala'), findsOneWidget);
      t.view.viewInsets = const FakeViewPadding(bottom: 260);
      await t.pump();
      await t.enterText(find.byType(TextFormField), '779999999');
      await tap(t, 'Send code');
      await t.enterText(find.byType(TextField), '123456');
      await tap(t, 'Verify');
      await t.enterText(find.byType(TextFormField).first, 'Small Screen');
      await t.pumpAndSettle();
      await t.drag(
        find.byType(SingleChildScrollView).last,
        const Offset(0, -300),
      );
      await t.pumpAndSettle();
      await tap(t, 'Create driver account');
      expect(find.textContaining('Agree to the Terms'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('splash timer is cancelled on disposal', (t) async {
    await t.pumpWidget(const NovaSysApp());
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 2));
    expect(t.takeException(), isNull);
  });
}
