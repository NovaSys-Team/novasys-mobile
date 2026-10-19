# NovaSys mobile

One Flutter Android application for Parent and Driver users, with simulated authentication.
The primary visual references are the five screenshots in `design_reference/auth_screenshots/`.
Individual elements from `design_reference/auth_latest/` supply the decorative bus scene and
Google mark. Screens and controls are Flutter widgets, not screenshot backgrounds.

## Navigation

- App launch: Splash (1.4 seconds) → Initial.
- Create an Account: Initial → Welcome / Language → Parent or Driver selection → Mobile number → OTP → Registration → selected-role dashboard placeholder.
- Sign In: Initial → Mobile number → OTP → stored-role dashboard for existing accounts.
- A new number entered through Sign In selects a role after OTP, then registers.
- Back and Change preserve the working flow. Existing dashboard placeholders and their sign-out behavior are unchanged.

## Local demo

- Parent: `77 123 4567`; Driver: `77 234 5678`.
- Any other valid Sri Lankan mobile number starts new-user registration.
- Any six digits verify a requested mock OTP. Resend is available after 30 seconds;
  challenges expire after five minutes and cannot be verified twice.
- Registration requires a name and consent. Email and sample profile avatar are optional.
- Google opens an explicitly simulated account selector. Profile photo uses a sample avatar.
- Accounts exist only for this app session. Language preference is retained in memory;
  full Sinhala/Tamil interface translations are not included.
- No Firebase, SMS, OAuth, backend APIs, GPS, or payment processing is connected.

## Structure

`lib/models/`, `lib/views/`, `lib/controllers/`, and `lib/repositories/` preserve MVC separation.
`lib/theme/auth_theme.dart` scopes the updated appearance to authentication.
The global theme and dashboard implementations are preserved.

## Run and checks

```sh
flutter run
dart format lib test
flutter analyze
flutter test
```

Source edits do not update the already-installed phone APK; run/reinstall the app to see them.
Tests exercise both signup roles, returning accounts, new numbers via Sign In, validation,
consent, photo simulation, Google simulation, OTP/resend, back navigation, splash disposal,
and a 320×640 screen with keyboard insets.

## Design assumptions

The low-resolution screenshots do not identify the font family or splash timing. Android's
standard Roboto typography and a 1.4-second splash are used. Role Selection includes a
bottom Continue action as requested, although that action is not visible in its screenshot.
Safe-area padding and scrolling adapt the 390×844 reference proportions to real devices;
mock sample field values and consent are not prefilled for new users.
