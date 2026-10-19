import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/controllers/auth_controller.dart';
import 'package:novasys_mobile/models/app_user.dart';
import 'package:novasys_mobile/models/auth_validators.dart';
import 'package:novasys_mobile/repositories/auth_repository.dart';

void main() {
  test('phone validation normalizes local and international forms', () {
    expect(AuthValidators.normalizePhone('+94 77 123 4567'), '771234567');
    expect(AuthValidators.phone('0771234567'), isNull);
    expect(AuthValidators.phone('123'), isNotNull);
    expect(AuthValidators.email(''), isNull);
    expect(AuthValidators.email('bad'), isNotNull);
  });
  test('verification requires an issued challenge and six digits', () async {
    final r = DemoAuthRepository();
    await expectLater(
      r.verifyCode('771234567', '123456'),
      throwsA(isA<AuthException>()),
    );
    await r.sendCode('771234567');
    await expectLater(
      r.verifyCode('771234567', '1234'),
      throwsA(isA<AuthException>()),
    );
    expect((await r.verifyCode('771234567', '654321'))!.role, UserRole.parent);
    await expectLater(
      r.verifyCode('771234567', '123456'),
      throwsA(isA<AuthException>()),
    );
  });
  test(
    'new driver registration persists stored role for later sign in',
    () async {
      final c = AuthController(DemoAuthRepository());
      addTearDown(c.dispose);
      expect(await c.sendCode('779999999'), isTrue);
      expect(await c.resendCode(), isFalse);
      expect(await c.verify('123456'), isTrue);
      expect(c.user, isNull);
      c.selectRole(UserRole.driver);
      expect(
        await c.register(
          name: 'Demo Driver',
          email: '',
          consent: false,
          hasPhoto: false,
        ),
        isFalse,
      );
      expect(
        await c.register(
          name: 'Demo Driver',
          email: '',
          consent: true,
          hasPhoto: true,
        ),
        isTrue,
      );
      expect(c.user!.hasPhoto, isTrue);
      c.signOut();
      await c.sendCode('779999999');
      await c.verify('654321');
      expect(c.user!.role, UserRole.driver);
    },
  );
  test('registration cannot bypass verification and duplicate submission is blocked', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    expect(
      await c.register(
        name: 'Demo User',
        email: '',
        consent: true,
        hasPhoto: false,
      ),
      isFalse,
    );
    final send = c.sendCode('771234567');
    expect(c.busy, isTrue);
    expect(await c.sendCode('772345678'), isFalse);
    await send;
    expect(c.busy, isFalse);
    c.cancelVerification();
    expect(await c.verify('123456'), isFalse);
  });
  test('both Google demo accounts preserve their roles', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    for (final role in UserRole.values) {
      expect(await c.googleDemo(role), isTrue);
      expect(c.user!.role, role);
      c.signOut();
      expect(c.user, isNull);
    }
  });
}
