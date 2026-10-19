import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/main.dart';

Future<void> tap(WidgetTester t, String text) async {
  final f = find.text(text);
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

Future<void> start(WidgetTester t, String phone) async {
  await t.pumpWidget(const NovaSysApp());
  await tap(t, 'Continue');
  await t.enterText(find.byType(TextFormField), phone);
  await tap(t, 'Send code');
}

void main() {
  for (final entry in [('771234567', 'Parent'), ('772345678', 'Driver')]) {
    testWidgets('${entry.$2} OTP sign in and sign out', (t) async {
      await start(t, entry.$1);
      await t.enterText(find.byType(TextField), '123456');
      await tap(t, 'Verify');
      expect(find.text('${entry.$2} dashboard'), findsOneWidget);
      await tap(t, 'Sign out');
      expect(find.text('Safe rides to school,\nevery day'), findsOneWidget);
    });
  }
  testWidgets(
    'phone validation, six-digit gate, resend cooldown, and change number',
    (t) async {
      await t.pumpWidget(const NovaSysApp());
      await tap(t, 'Continue');
      await tap(t, 'Send code');
      expect(find.textContaining('Enter a valid 9-digit'), findsOneWidget);
      await t.enterText(find.byType(TextFormField), '779999999');
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
    },
  );
  testWidgets(
    'registration validates consent and name, selects Driver and optional photo',
    (t) async {
      await start(t, '779999999');
      await t.enterText(find.byType(TextField), '123456');
      await tap(t, 'Verify');
      await tap(t, 'Create parent account');
      expect(find.text('Enter your full name.'), findsOneWidget);
      await t.enterText(find.byType(TextFormField).first, 'New Driver');
      await tap(t, 'Driver');
      await tap(t, 'Create driver account');
      expect(find.textContaining('Agree to the Terms'), findsOneWidget);
      await tap(t, 'Profile photo');
      await tap(t, 'Use demo photo');
      await t.ensureVisible(find.byType(Checkbox));
      await t.tap(find.byType(Checkbox));
      await t.pumpAndSettle();
      await tap(t, 'Create driver account');
      expect(find.text('Driver dashboard'), findsOneWidget);
    },
  );
  testWidgets('Google is explicitly simulated and keeps existing role', (
    t,
  ) async {
    await t.pumpWidget(const NovaSysApp());
    await tap(t, 'Continue');
    await tap(t, 'Continue with Google');
    expect(find.text('Google sign-in demo'), findsOneWidget);
    await tap(t, 'Driver demo');
    expect(find.text('Driver dashboard'), findsOneWidget);
  });
  testWidgets('language selection and small-screen scrolling remain usable', (
    t,
  ) async {
    t.view.physicalSize = const Size(320, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(const NovaSysApp());
    await tap(t, 'සිංහල');
    await tap(t, 'Continue');
    expect(find.text('Sinhala'), findsOneWidget);
    t.view.viewInsets = const FakeViewPadding(bottom: 260);
    await t.pump();
    await t.enterText(find.byType(TextFormField), '771234567');
    await tap(t, 'Send code');
    expect(find.text('Enter the code'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
