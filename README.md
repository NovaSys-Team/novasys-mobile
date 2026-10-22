# NovaSys mobile

One Flutter Android application for Parent and Driver users, with simulated authentication.
The primary visual references are the five screenshots in `design_reference/auth_screenshots/`.
Individual elements from `design_reference/auth_latest/` supply the decorative bus scene and
Google mark. Screens and controls are Flutter widgets, not screenshot backgrounds.

## Repository layout

- Repository root — the Flutter Android application (`lib/`, `test/`, `android/`, `assets/`).
- `backend/` — Spring Boot (Java 21) service foundation. Starts, uses an in-memory H2
  development database and exposes an Actuator health check; it has no domain endpoints
  and the Flutter app does not call it. See [`backend/README.md`](backend/README.md).

## Navigation

- App launch: Splash (1.4 seconds) → Welcome (P01).
- Get started: Welcome → Parent or Driver selection → Email (P02) → Email code (P02B) → Registration → selected-role dashboard placeholder.
- I already have an account: Welcome → Email → Email code → stored-role dashboard for existing accounts.
- A new address entered through sign in selects a role after the code, then registers.
- Email is the sign-in identity; the mobile number is now an optional registration field.
- Language selection has been removed from authentication. The interface is English only.
- Back and Change email preserve the working flow. Existing dashboard placeholders and their sign-out behavior are unchanged.

## Local demo

**No email is ever sent.** The six-digit code is accepted on the device, so the code screen
labels itself `PROTOTYPE SHORTCUTS` and offers the two sample identities directly.

- Parent: `nadeesha.p@example.com`; Driver: `kasun.s@example.com`.
- Any other valid address starts new-user registration.
- Any six digits verify a requested mock code. Resend is available after 45 seconds;
  challenges expire after ten minutes and cannot be verified twice.
- Registration requires a name and consent. Mobile number and sample profile avatar are
  optional; the verified email address is shown but cannot be edited there.
- Google opens an explicitly simulated account selector; no Google OAuth is performed.
- Accounts exist only for this app session.
- No Firebase, email delivery, OAuth, backend APIs, GPS, or payment processing is connected.

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
Tests exercise both signup roles, returning accounts, new addresses via sign in, email and
mobile validation, consent, photo simulation, Google simulation, code gating/resend,
prototype shortcuts, back navigation, splash disposal, a 320×640 screen with keyboard
insets, and layout of the three authentication screens at 390×844, 360×640 and 320×568.

## Design assumptions

The references do not identify the font family or splash timing. Android's standard Roboto
typography and a 1.4-second splash are used. Role Selection includes a bottom Continue
action as requested, although that action is not visible in its screenshot.
Safe-area padding and scrolling adapt the 390×844 reference proportions to real devices;
mock sample field values and consent are not prefilled for new users. The Welcome header
takes the height its copy and buttons do not need, capped at the reference 62% band, and
the secondary Welcome button keeps a 48pt touch target rather than the reference 30pt.
The reference email field shows a filled sample address; a `you@example.com` hint is used
instead so the field starts empty. Authentication headings are measured from the references
at 30pt (32pt on Welcome) with no negative tracking, so `auth_theme.dart` overrides the
global 28pt/-0.6 `headlineMedium`; body copy on Welcome and the email screen is 16pt.
At the 390pt reference width the email heading is one line, and it wraps to two below
roughly 370pt.
