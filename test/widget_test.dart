import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/main.dart';
import 'package:novasys_mobile/repositories/auth_repository.dart';
import 'package:novasys_mobile/views/entry_views.dart';
import 'package:novasys_mobile/views/parent/parent_preview.dart';
import 'package:novasys_mobile/views/registration_view.dart';
import 'package:novasys_mobile/views/role_selection_view.dart';
import 'package:novasys_mobile/views/widgets/otp_boxes.dart';

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
  expect(find.text('Safe rides to school, every day'), findsOneWidget);
}

Future<void> sendCodeTo(WidgetTester t, String email) async {
  await t.enterText(find.byType(TextFormField), email);
  await tap(t, 'Send code');
}

Future<void> enterCode(WidgetTester t, String code) async {
  await t.enterText(
    find.descendant(
      of: find.byType(OtpBoxes),
      matching: find.byType(TextField),
    ),
    code,
  );
  await t.pumpAndSettle();
}

Future<void> signIn(WidgetTester t, String email) async {
  await launch(t);
  await tap(t, 'I already have an account');
  expect(find.text('Sign in or create account'), findsOneWidget);
  await sendCodeTo(t, email);
  expect(find.text('Check your email'), findsOneWidget);
}

Future<void> signup(WidgetTester t, String role) async {
  await launch(t);
  await tap(t, 'Get started');
  expect(find.byType(RoleSelectionView), findsOneWidget);
  await tap(t, role);
  await tap(t, 'Continue');
  await sendCodeTo(t, 'new.${role.toLowerCase()}@example.com');
  await enterCode(t, '123456');
  await tap(t, 'Verify & continue');
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
        // The verified email is carried into registration.
        expect(
          find.text('new.${role.toLowerCase()}@example.com'),
          findsOneWidget,
        );
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.text('Enter your full name.'), findsOneWidget);
        await t.enterText(find.byType(TextFormField).first, 'New $role');
        await t.enterText(find.byType(TextFormField).last, '123');
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.textContaining('valid 9-digit'), findsOneWidget);
        await t.enterText(find.byType(TextFormField).last, '');
        await tap(t, 'Create ${role.toLowerCase()} account');
        expect(find.textContaining('Agree to the Terms'), findsOneWidget);
        await tap(t, 'Profile photo');
        await tap(t, 'Use demo photo');
        await t.ensureVisible(find.byType(Checkbox));
        await t.tap(find.byType(Checkbox));
        await t.pumpAndSettle();
        await tap(t, 'Create ${role.toLowerCase()} account');
        if (role == 'Parent') {
          expect(find.byType(ParentHomePreview), findsOneWidget);
          expect(find.text('Mrs. Perera'), findsOneWidget);
        } else {
          expect(find.text('Verify your documents'), findsOneWidget);
          await tap(t, 'Sign out');
          expect(find.byType(InitialView), findsOneWidget);
        }
      },
    );
  }

  for (final entry in [
    (DemoEmails.parent, 'Parent'),
    (DemoEmails.driver, 'Driver'),
  ]) {
    testWidgets('${entry.$2} existing account bypasses registration', (
      t,
    ) async {
      await signIn(t, entry.$1);
      expect(find.text('${entry.$1}.'), findsOneWidget);
      await enterCode(t, '123456');
      await tap(t, 'Verify & continue');
      if (entry.$2 == 'Parent') {
        expect(find.byType(ParentHomePreview), findsOneWidget);
      } else {
        expect(find.text('Verify your documents'), findsOneWidget);
      }
    });
  }

  testWidgets('new address via sign in selects role after verification', (
    t,
  ) async {
    await signIn(t, 'fresh@example.com');
    await enterCode(t, '123456');
    await tap(t, 'Verify & continue');
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
    expect(find.byType(ParentHomePreview), findsOneWidget);
  });

  testWidgets('email validation, code gating, resend and change email', (
    t,
  ) async {
    await launch(t);
    await tap(t, 'I already have an account');
    await tap(t, 'Send code');
    expect(find.text('Enter your email address.'), findsOneWidget);
    await t.enterText(find.byType(TextFormField), 'not-an-email');
    await tap(t, 'Send code');
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    await sendCodeTo(t, DemoEmails.parent);
    expect(find.text('Enter the 6-digit code from your email'), findsOneWidget);
    await enterCode(t, '1234');
    expect(
      t
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Verify & continue'),
          )
          .onPressed,
      isNull,
    );
    await enterCode(t, '123456');
    expect(find.text('Code complete · tap Verify'), findsOneWidget);
    expect(find.textContaining('Resend in'), findsOneWidget);
    await t.pump(const Duration(seconds: 46));
    await t.pumpAndSettle();
    await tap(t, 'Resend code');
    expect(find.textContaining('Resend in'), findsOneWidget);
    await tap(t, 'Change email');
    expect(find.text('Sign in or create account'), findsOneWidget);
    // The address is kept so it does not have to be retyped.
    expect(find.text(DemoEmails.parent), findsOneWidget);
  });

  testWidgets('prototype shortcut signs in as the sample parent', (t) async {
    await signIn(t, 'fresh@example.com');
    await tap(t, 'Existing parent');
    expect(find.byType(ParentHomePreview), findsOneWidget);
  });

  testWidgets('prototype shortcut opens the new account path', (t) async {
    await signIn(t, 'fresh@example.com');
    await tap(t, 'Create account');
    expect(find.byType(RoleSelectionView), findsOneWidget);
  });

  testWidgets('Google remains an explicit simulation', (t) async {
    await launch(t);
    await tap(t, 'I already have an account');
    await tap(t, 'Continue with Google');
    expect(find.text('Google sign-in demo'), findsOneWidget);
    expect(find.textContaining('not wired up yet'), findsOneWidget);
    await tap(t, 'Driver demo');
    expect(find.text('Verify your documents'), findsOneWidget);
    expect(find.text('Signed in with Google'), findsOneWidget);
  });

  testWidgets('small screen, back navigation and registration keyboard', (
    t,
  ) async {
    t.view.physicalSize = const Size(320, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    addTearDown(t.view.resetViewInsets);
    await launch(t);
    await tap(t, 'Get started');
    await tap(t, 'Driver');
    await t.ensureVisible(find.byTooltip('Back'));
    await t.tap(find.byTooltip('Back'));
    await t.pumpAndSettle();
    expect(find.byType(InitialView), findsOneWidget);
    await tap(t, 'Get started');
    await tap(t, 'Parent');
    await tap(t, 'Continue');
    t.view.viewInsets = const FakeViewPadding(bottom: 260);
    await t.pump();
    await sendCodeTo(t, 'small.screen@example.com');
    await enterCode(t, '123456');
    await tap(t, 'Verify & continue');
    await t.enterText(find.byType(TextFormField).first, 'Small Screen');
    await t.pumpAndSettle();
    await t.drag(
      find.byType(SingleChildScrollView).last,
      const Offset(0, -300),
    );
    await t.pumpAndSettle();
    await tap(t, 'Create parent account');
    expect(find.textContaining('Agree to the Terms'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  for (final size in [
    const Size(390, 844),
    const Size(360, 640),
    const Size(320, 568),
  ]) {
    testWidgets('the three auth screens lay out at ${size.width.toInt()}x'
        '${size.height.toInt()}', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await launch(t);
      expect(find.text('Get started'), findsOneWidget);
      await tap(t, 'I already have an account');
      expect(find.text('Email address'), findsOneWidget);
      await sendCodeTo(t, DemoEmails.driver);
      expect(find.byType(OtpBoxes), findsOneWidget);
      expect(find.text('Verification code'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  }

  testWidgets('splash timer is cancelled on disposal', (t) async {
    await t.pumpWidget(const NovaSysApp());
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 2));
    expect(t.takeException(), isNull);
  });
}
