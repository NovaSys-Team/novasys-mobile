import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/controllers/auth_controller.dart';
import 'package:novasys_mobile/models/app_user.dart';
import 'package:novasys_mobile/models/driver_verification.dart';
import 'package:novasys_mobile/repositories/auth_repository.dart';
import 'package:novasys_mobile/repositories/mock_verification_repository.dart';
import 'package:novasys_mobile/theme/app_theme.dart';
import 'package:novasys_mobile/views/auth_views.dart';
import 'package:novasys_mobile/views/driver_verification_view.dart';
import 'package:novasys_mobile/views/driver_account_completion_view.dart';
import 'package:novasys_mobile/views/entry_views.dart';

Future<void> tap(WidgetTester t, Finder finder) async {
  await t.ensureVisible(finder);
  await t.pumpAndSettle();
  await t.tap(finder);
  await t.pumpAndSettle();
}

void main() {
  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('D01 workflow, safe area and navigation at $size', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = 1;
      t.view.padding = const FakeViewPadding(top: 24, bottom: 24);
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.view.resetPadding);
      final auth = AuthController(DemoAuthRepository());
      addTearDown(auth.dispose);
      auth.user = const AppUser(
        name: 'Ruwan Jayasinghe',
        email: DemoEmails.driver,
        phone: '772345678',
        role: UserRole.driver,
      );
      await t.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: DashboardView(controller: auth),
        ),
      );
      expect(find.byType(DriverVerificationView), findsOneWidget);
      expect(find.text('Required documents · 2 of 4'), findsOneWidget);
      expect(find.text('Signed in with phone'), findsOneWidget);
      expect(find.text('Signed in with Google'), findsNothing);
      final submit = find.byKey(const Key('submit-verification'));
      expect(t.widget<FilledButton>(submit).onPressed, isNull);
      await tap(t, find.byKey(const Key('upload-police')));
      await tap(t, find.text('Cancel'));
      expect(find.text('Required documents · 2 of 4'), findsOneWidget);
      for (final entry in [('police', 3), ('registration', 4)]) {
        await tap(t, find.byKey(Key('upload-${entry.$1}')));
        await tap(t, find.text('Add mock document'));
        expect(
          find.text('Required documents · ${entry.$2} of 4'),
          findsOneWidget,
        );
      }
      expect(t.widget<FilledButton>(submit).onPressed, isNotNull);
      await tap(t, submit);
      expect(
        auth.driverVerification.verification.status,
        VerificationStatus.pendingReview,
      );
      expect(find.text('Under review'), findsOneWidget);
      expect(find.text('Added'), findsNWidgets(4));
      expect(find.textContaining('An admin must approve'), findsOneWidget);
      expect(submit, findsNothing);
      expect(auth.driverVerification.submit(), isFalse);
      expect(
        auth.driverVerification.verification.canAccessDriverFeatures,
        isFalse,
      );
      expect(find.text('Driver dashboard'), findsNothing);
      // Recreate the route with the same session, as when navigating back.
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: DashboardView(controller: auth),
        ),
      );
      expect(find.text('Under review'), findsOneWidget);
      expect(find.text('Required documents · 4 of 4'), findsOneWidget);
      expect(t.takeException(), isNull);
      await tap(t, find.text('Demo: admin approves'));
      expect(
        auth.driverVerification.verification.status,
        VerificationStatus.approved,
      );
      expect(find.text('You’re approved'), findsOneWidget);
      expect(find.text('Next: finish your account'), findsOneWidget);
      expect(find.text('Demo: admin approves'), findsNothing);
      expect(find.text('Added'), findsNothing);
      expect(auth.driverVerification.verification.documents.length, 4);
      expect(
        auth.driverVerification.verification.canAccessDriverFeatures,
        isFalse,
      );
      expect(auth.driverVerification.demoApprove(), isFalse);
      expect(auth.driverVerification.submit(), isFalse);
      await tap(t, find.text('Complete account'));
      expect(find.byType(DriverAccountCompletionView), findsOneWidget);
      expect(find.textContaining('pending implementation'), findsOneWidget);
      await t.pageBack();
      await t.pumpAndSettle();
      expect(find.text('You’re approved'), findsOneWidget);
      // Authentication routing must retain Approved rather than open a dashboard.
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: DashboardView(controller: auth),
        ),
      );
      expect(find.text('You’re approved'), findsOneWidget);
      expect(find.text('Driver dashboard'), findsNothing);
      expect(t.takeException(), isNull);
      await tap(t, find.text('Sign out'));
      expect(auth.user, isNull);
      expect(
        auth.driverVerification.verification.status,
        VerificationStatus.incomplete,
      );
      expect(auth.driverVerification.verification.documents.length, 2);
      expect(find.byType(InitialView), findsOneWidget);
    });
  }

  testWidgets('long profile and large text scroll without overflow', (t) async {
    t.view.physicalSize = const Size(320, 568);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final auth = AuthController(DemoAuthRepository());
    addTearDown(auth.dispose);
    auth.user = const AppUser(
      name: 'Ruwan Jayasinghe Long Driver Name',
      email: DemoEmails.driver,
      phone: '772345678',
      role: UserRole.driver,
    );
    await t.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: DashboardView(controller: auth),
      ),
    );
    await t.ensureVisible(find.byKey(const Key('submit-verification')));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    for (final document in DriverDocument.values) {
      auth.driverVerification.addDocument(document);
    }
    auth.driverVerification.submit();
    await t.pumpAndSettle();
    await tap(t, find.text('Demo: admin approves'));
    await t.ensureVisible(find.text('Complete account'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  test('empty simulation and approval restrictions', () {
    final repository = MockVerificationRepository(demoMode: false);
    expect(repository.verification.documents, isEmpty);
    expect(repository.demoApprove(), isFalse);
    expect(repository.submit(), isFalse);
    for (final doc in DriverDocument.values) {
      repository.add(doc);
    }
    expect(repository.submit(), isTrue);
    expect(repository.add(DriverDocument.licence), isFalse);
    expect(repository.submit(), isFalse);
    expect(repository.demoApprove(), isFalse); // Disabled outside demo mode.
    for (final status in VerificationStatus.values) {
      expect(
        DriverVerification(
          documents: {},
          status: status,
        ).canAccessDriverFeatures,
        isFalse,
      );
    }
  });

  test('demo approval requires review and preserves all documents', () {
    final repository = MockVerificationRepository();
    expect(repository.demoApprove(), isFalse);
    repository.add(DriverDocument.police);
    expect(repository.submit(), isFalse);
    repository.add(DriverDocument.registration);
    expect(repository.submit(), isTrue);
    expect(repository.demoApprove(), isTrue);
    expect(repository.verification.canCompleteAccount, isTrue);
    expect(repository.verification.documents.length, 4);
    expect(repository.demoApprove(), isFalse);
    expect(repository.add(DriverDocument.licence), isFalse);
    expect(repository.submit(), isFalse);
    repository.clear();
    expect(repository.verification.status, VerificationStatus.incomplete);
    expect(repository.verification.documents.length, 2);
  });
}
