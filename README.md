# NovaSys mobile

One Flutter Android app for Parent and Driver users. The authentication UI follows
`design_reference/parent/P01`, `P02`, `P02B`, and `P02C` (the four supplied SVGs).
These files were copied from Downloads because the local parent reference folder was absent.
All screens, controls, and the welcome illustration are Flutter widgets/CustomPaint;
the full-screen reference SVGs are not bundled or displayed in the app.

## Run and demo flow

```sh
flutter pub get
flutter run
```

Welcome / language selection → mobile number → verification → existing role dashboard
or new-user registration. Registration includes name, optional email, sample avatar,
Parent/Driver selection, and required consent. Back/Change returns to the mobile form.

- Parent demo: `77 123 4567`.
- Driver demo: `77 234 5678`.
- Any other valid Sri Lankan mobile number starts registration.
- Enter any **six digits** for the simulated OTP. Codes expire after five minutes;
  resend is available after 30 seconds. A code cannot be verified twice.
- OTP shortcuts open a new account flow or an existing Parent/Driver sample account.
- Continue with Google opens an explicitly simulated account selector, not OAuth.
- Profile photo offers a sample avatar, without accessing the camera or gallery.
- The selected language is retained in memory and shown on the mobile screen;
  this design update does not include full Sinhala/Tamil translations.

Accounts survive sign-out in the current session and reset when the app restarts.
Returning users always open their stored role. Only use sample details. No SMS,
backend, Firebase, payment, GPS, or real Google requests are made. Dashboards remain
minimal placeholders. The Android project configuration is preserved.

## MVC structure

- `lib/models/`: account/role model and validators.
- `lib/controllers/auth_controller.dart`: flow state, verification, cooldown, consent,
  role selection, loading/errors, and session management.
- `lib/repositories/auth_repository.dart`: replaceable repository interface and local
  asynchronous simulation with seeded Parent and Driver accounts.
- `lib/views/`: welcome, mobile login, OTP, registration, and dashboard placeholders.
- `lib/views/widgets/`: responsive shared layout, controls, and painted welcome scene.
- `lib/theme/app_theme.dart`: teal, mint, white surfaces, typography, and field styles.

## Checks

```sh
dart format lib test
flutter analyze
flutter test
```

Tests cover phone normalization, issued/consumed challenges, six-digit validation,
resend cooldown, consent, registration, stored roles, duplicate submission guards,
Google simulation, sign-out, language selection, and narrow screens with keyboard insets.
