# DOCTOR — Hospital Appointment & Role-Based App

Short description
-----------------

DOCTOR is a Flutter app (mobile + web) for a hospital-style system that supports three user roles: Admin, Doctor and Patient. It provides authentication with Firebase, role-based dashboards, signup/login flows, and basic data storage in Firestore. This repository is the working app used for development and testing.

Detailed description
--------------------

This project is a Flutter application scaffolded for cross-platform (Android, iOS, Web, Windows, macOS, Linux) and uses Firebase for authentication and Firestore for data storage. Core features include:

- Role-based authentication and navigation (Admin, Doctor, Patient)
- Sign-up flows for Doctor and Patient (Doctor includes education fields)
- Firebase-backed `AuthProvider` using Provider for state management
- Seeded developer/test accounts via `lib/services/database_initializer.dart`
- Simple dashboards for each role in `lib/screens/*/` with logout

Architecture & tech
-------------------

- Flutter (Dart)
- Firebase: firebase_auth, cloud_firestore, firebase_core, firebase_storage
- Provider for state management
- Project root: `lib/` contains the app code; `web/index.html` is the web entry

Quick start (Development)
-------------------------

Make sure you have Flutter installed and configured for web (or your target platforms).

1. Open a PowerShell terminal in the project root (`d:\Computer\Codings\Flutter\doctor`).

2. Run Flutter commands (PowerShell style):

```powershell
flutter clean; flutter pub get
flutter run -d chrome
```

Or build for web:

```powershell
flutter clean; flutter pub get; flutter build web --release
```

Firebase setup (required)
------------------------

This project expects Firebase to be configured. The FlutterFire CLI normally generates `lib/firebase_options.dart`. If you haven't already:

1. Create a Firebase project in the Firebase Console.
2. Register Android/iOS/web app and follow the Firebase setup instructions.
3. Run FlutterFire CLI to generate `firebase_options.dart` or copy your existing config into `lib/firebase_options.dart`.

Notes:
- The code calls `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` in `lib/main.dart`.
- If you plan to publish, double-check `web/index.html` for the proper Firebase web SDK initialization.

Seeded test accounts (development)
---------------------------------

For quicker local testing, `lib/services/database_initializer.dart` seeds sample accounts. Default test credentials (created by the initializer) are:

- Admin: `admin@hospital.com` / `Admin@123`
- Doctor: `doctor@hospital.com` / `Doctor@123`
- Patient: `patient@example.com` / `Patient@123`

If you prefer not to auto-create accounts on each startup, edit `lib/main.dart` and remove or guard the `DatabaseInitializer().initializeData()` call (recommended: call only in debug mode using `kDebugMode`).

Provider & login notes
----------------------

- The app uses `AuthProvider` (`lib/providers/auth_provider.dart`) which listens to Firebase auth state and detects user role by checking Firestore collections `admins`, `doctors`, and `patients`.
- Login screens now explicitly pass roles when authenticating (e.g., `role: 'doctor'`), and navigation to role dashboards occurs only on successful role verification.

Removed manager role
--------------------

Per the current branch, the `manager` role was removed from the UI. Placeholder files remain in `lib/screens/manager_*` so imports won't break; you can safely delete those files if you prefer to remove them entirely.

Validator and forms
-------------------

- The project includes `lib/form_validator.dart` which centralizes validators (name, age, phone, email, password rules, CNIC, etc.).
- Most sign-up forms use those validators; if you want a full sweep to apply `FormValidator` consistently to every field, I can do that in a follow-up.

Common troubleshooting
----------------------

- White screen on web: ensure `web/index.html` contains the proper Flutter bootstrap (the `flutter.js` loader) and your `main.dart.js` is present after `flutter build web`.
- Missing asset 404s: verify `pubspec.yaml` includes the `assets/` directories and that image paths in code match exactly (case-sensitive on web servers).
- ProviderNotFound: ensure the `ChangeNotifierProvider` for `AuthProvider` is registered above the widgets that call `Provider.of<AuthProvider>(...)`. `lib/main.dart` was updated to register it at app root.

Recommended next steps
----------------------

1. Wrap `DatabaseInitializer` so it runs only in debug mode. I can apply this change.
2. Remove manager placeholder files if you want them gone.
3. Run `flutter build web` and test the produced `build/web` locally or deploy to Firebase Hosting.
4. (Optional) I can add a short test harness that signs in with seeded users and asserts role-based routing.

Contributing
------------

Feel free to open issues or pull requests. Keep changes small and focused; follow existing project style. If you want me to add CI (GitHub Actions) to run a basic `flutter analyze` and `flutter test`, tell me which platforms to target and I'll scaffold it.

License
-------

Add whichever license you prefer. If you want a recommendation, the MIT license is permissive and simple — I can add a `LICENSE` file for you.

Contact
-------

If you want me to continue and: remove placeholders, enforce form validators globally, or make DatabaseInitializer debug-only — pick one and I'll apply the change.

---

README generated by an automated assistant to help publish this project to GitHub; update any project-specific secrets and Firebase configuration before pushing.
# doctor

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
