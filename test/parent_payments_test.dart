import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/controllers/parent_home_controller.dart';
import 'package:novasys_mobile/controllers/parent_payments_controller.dart';
import 'package:novasys_mobile/models/parent_payment.dart';
import 'package:novasys_mobile/theme/app_theme.dart';
import 'package:novasys_mobile/views/parent/parent_home_shell.dart';
import 'package:novasys_mobile/views/parent/payments/checkout_view.dart';
import 'package:novasys_mobile/views/parent/payments/payments_view.dart';

Future<void> tap(WidgetTester t, String label) async {
  if (find.text(label).evaluate().isEmpty) {
    await t.scrollUntilVisible(
      find.text(label),
      160,
      scrollable: find.byType(Scrollable).last,
    );
  }
  final finder = find.text(label).last;
  await t.ensureVisible(finder);
  await t.pumpAndSettle();
  await t.tap(finder);
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
  final controller = ParentHomeController()..selectNavTab(2);
  addTearDown(controller.dispose);
  await t.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: ParentHomeShell(controller: controller),
    ),
  );
  return controller;
}

void main() {
  test(
    'failed attempts preserve history; retry succeeds once; reset is isolated',
    () {
      final c = ParentPaymentsController();
      addTearDown(c.dispose);
      expect(c.history.length, 3);
      expect(
        c.checkout(succeed: false, method: DemoPaymentMethod.card),
        isNull,
      );
      expect(c.isPaid, isFalse);
      expect(c.history.length, 3);
      final receipt = c.checkout(
        succeed: true,
        method: DemoPaymentMethod.banking,
      );
      expect(receipt!.amount, 17000);
      expect(receipt.method, DemoPaymentMethod.banking);
      expect(c.isPaid, isTrue);
      expect(c.history.first, receipt);
      c.checkout(succeed: true, method: DemoPaymentMethod.card);
      expect(c.history.length, 4);
      expect(() => c.history.clear(), throwsUnsupportedError);
      c.resetDemo();
      expect(c.history.length, 3);
      expect(c.isPaid, isFalse);
    },
  );

  testWidgets('Parent navigation and Home Pay now reach payments', (t) async {
    final c = await launch(t);
    await tap(t, 'Home');
    await t.scrollUntilVisible(
      find.text('Pay now'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tap(t, 'Pay now');
    expect(find.byType(PaymentsView), findsOneWidget);
    expect(c.bottomNavIndex, 2);
    await t.tap(find.byTooltip('Back'));
    await t.pumpAndSettle();
    expect(c.bottomNavIndex, 0);
    await tap(t, 'Payments');
    expect(find.byType(PaymentsView), findsOneWidget);
  });

  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets(
      'success validates consent, records receipt and survives tab changes at $size',
      (t) async {
        final c = await launch(t, size: size);
        await tap(t, 'Pay LKR 17,000');
        await tap(t, 'Simulate successful payment');
        expect(find.text('Confirm demo mode to continue.'), findsOneWidget);
        expect(c.payments.isPaid, isFalse);
        await tap(t, 'I understand this is a demo payment.');
        await tap(t, 'Mobile wallet');
        await tap(t, 'Simulate successful payment');
        expect(find.text('Payment confirmed'), findsOneWidget);
        expect(c.payments.history.length, 4);
        expect(c.currentFee.isPaid, isTrue);
        expect(c.payments.receipt!.method, DemoPaymentMethod.wallet);
        expect(t.takeException(), isNull, reason: 'confirmed screen');
        await tap(t, 'View demo digital receipt');
        expect(t.takeException(), isNull, reason: 'receipt sheet');
        expect(find.text('Demo digital receipts'), findsOneWidget);
        await t.tap(find.byTooltip('Close'));
        await t.pumpAndSettle();
        await tap(t, 'Done');
        expect(find.byType(CheckoutView), findsNothing);
        expect(find.text('Paid • DEMO'), findsOneWidget);
        await tap(t, 'Account');
        await tap(t, 'Payments');
        expect(c.payments.history.length, 4);
        expect(find.text('View demo receipt'), findsOneWidget);
        expect(t.takeException(), isNull);
      },
    );

    testWidgets(
      'failed checkout, retry and back preserve unpaid state at $size',
      (t) async {
        final c = await launch(t, size: size);
        await tap(t, 'Pay LKR 17,000');
        await tap(t, 'I understand this is a demo payment.');
        await tap(t, 'Demo: simulate failed payment');
        expect(find.text('Payment failed'), findsOneWidget);
        expect(c.payments.history.length, 3);
        expect(c.currentFee.isPaid, isFalse);
        await tap(t, 'Try again');
        expect(find.byType(CheckoutView), findsOneWidget);
        await tap(t, 'Demo: simulate failed payment');
        await tap(t, 'Back to payments');
        expect(find.byType(PaymentsView), findsOneWidget);
        expect(c.payments.isPaid, isFalse);
        await tap(t, 'Pay LKR 17,000');
        await tap(t, 'I understand this is a demo payment.');
        await tap(t, 'Demo: simulate failed payment');
        await tap(t, 'Try again');
        await tap(t, 'Simulate successful payment');
        expect(find.text('Payment confirmed'), findsOneWidget);
        expect(c.payments.history.length, 4);
        expect(t.takeException(), isNull);
      },
    );
  }
}
