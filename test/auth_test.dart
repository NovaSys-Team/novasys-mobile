import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_mobile/controllers/auth_controller.dart';
import 'package:novasys_mobile/models/app_user.dart';
import 'package:novasys_mobile/models/auth_validators.dart';
import 'package:novasys_mobile/repositories/auth_repository.dart';

void main() {
  test('email validation trims, lowercases and rejects malformed input', () {
    expect(
      AuthValidators.normalizeEmail('  Nadeesha.P@Example.COM '),
      'nadeesha.p@example.com',
    );
    expect(AuthValidators.requiredEmail('nadeesha.p@example.com'), isNull);
    expect(AuthValidators.requiredEmail(''), isNotNull);
    expect(AuthValidators.requiredEmail('bad'), isNotNull);
    expect(AuthValidators.requiredEmail('bad@example'), isNotNull);
    expect(AuthValidators.requiredEmail('a b@example.com'), isNotNull);
    // The optional profile field still accepts a blank value.
    expect(AuthValidators.email(''), isNull);
    expect(AuthValidators.email('bad'), isNotNull);
    expect(AuthValidators.optionalPhone(''), isNull);
    expect(AuthValidators.optionalPhone('0771234567'), isNull);
    expect(AuthValidators.optionalPhone('123'), isNotNull);
  });

  test('verification requires an issued challenge and six digits', () async {
    final r = DemoAuthRepository();
    await expectLater(
      r.verifyCode(DemoEmails.parent, '123456'),
      throwsA(isA<AuthException>()),
    );
    await r.sendCode(DemoEmails.parent);
    await expectLater(
      r.verifyCode(DemoEmails.parent, '1234'),
      throwsA(isA<AuthException>()),
    );
    expect(
      (await r.verifyCode(DemoEmails.parent, '654321'))!.role,
      UserRole.parent,
    );
    // The challenge is single use.
    await expectLater(
      r.verifyCode(DemoEmails.parent, '123456'),
      throwsA(isA<AuthException>()),
    );
  });

  test('a code issued for one address cannot verify another', () async {
    final r = DemoAuthRepository();
    await r.sendCode(DemoEmails.parent);
    await expectLater(
      r.verifyCode(DemoEmails.driver, '123456'),
      throwsA(isA<AuthException>()),
    );
  });

  test(
    'new driver registration persists stored role for later sign in',
    () async {
      final c = AuthController(DemoAuthRepository());
      addTearDown(c.dispose);
      expect(await c.sendCode(' New.User@Example.com '), isTrue);
      expect(c.email, 'new.user@example.com');
      expect(c.resendSeconds, AuthController.resendCooldown);
      expect(await c.resendCode(), isFalse);
      expect(await c.verify('123456'), isTrue);
      expect(c.user, isNull);
      c.selectRole(UserRole.driver);
      expect(
        await c.register(
          name: 'Demo Driver',
          phone: '',
          consent: false,
          hasPhoto: false,
        ),
        isFalse,
      );
      expect(
        await c.register(
          name: 'Demo Driver',
          phone: '0771111111',
          consent: true,
          hasPhoto: true,
        ),
        isTrue,
      );
      expect(c.user!.hasPhoto, isTrue);
      expect(c.user!.phone, '771111111');
      expect(c.user!.email, 'new.user@example.com');
      c.signOut();
      expect(c.email, isEmpty);
      await c.sendCode('new.user@example.com');
      await c.verify('654321');
      expect(c.user!.role, UserRole.driver);
    },
  );

  test('an invalid mobile number blocks registration', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    await c.sendCode('someone@example.com');
    await c.verify('123456');
    expect(
      await c.register(
        name: 'Demo User',
        phone: '123',
        consent: true,
        hasPhoto: false,
      ),
      isFalse,
    );
    expect(c.error, isNotNull);
  });

  test('registration cannot bypass verification and duplicate submission is '
      'blocked', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    expect(
      await c.register(
        name: 'Demo User',
        phone: '',
        consent: true,
        hasPhoto: false,
      ),
      isFalse,
    );
    final send = c.sendCode(DemoEmails.parent);
    expect(c.busy, isTrue);
    expect(await c.sendCode(DemoEmails.driver), isFalse);
    await send;
    expect(c.busy, isFalse);
    c.cancelVerification();
    expect(await c.verify('123456'), isFalse);
  });

  test('an existing address signs straight in without registering', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    await c.sendCode(DemoEmails.parent);
    await c.verify('123456');
    expect(c.user!.name, 'Nadeesha Perera');
    expect(c.role, UserRole.parent);
    expect(
      await c.register(
        name: 'Someone Else',
        phone: '',
        consent: true,
        hasPhoto: false,
      ),
      isFalse,
    );
  });

  test('prototype shortcuts reach both sample identities', () async {
    final c = AuthController(DemoAuthRepository());
    addTearDown(c.dispose);
    expect(await c.shortcut(UserRole.parent), isTrue);
    expect(c.user!.email, DemoEmails.parent);
    c.signOut();
    expect(await c.shortcut(null), isTrue);
    expect(c.user, isNull);
    expect(c.verified, isTrue);
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
