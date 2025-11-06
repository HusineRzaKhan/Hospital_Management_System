# 🏥 Hospital Management System (HMS)

**Creator:** *Hussain Raza Khan*
**GitHub:** [HusineRzaKhan](https://github.com/HusineRzaKhan)

---

## 📖 Overview

The **Hospital Management System (HMS)** — also known as **DOCTOR** — is a cross-platform Flutter application designed for managing hospital operations efficiently. It features **role-based access** for Admins, Doctors, and Patients, integrated with Firebase Authentication and Firestore for secure data management.

This system simplifies appointment scheduling, user management, and data flow between hospital stakeholders through a clean and responsive interface.

---

## ⚙️ Key Features

* 🔐 **Role-Based Authentication** — Separate logins and dashboards for Admin, Doctor, and Patient.
* 👨‍⚕️ **Doctor & Patient Registration** — Includes custom sign-up fields (e.g., education for doctors).
* 🗂️ **Firebase Integration** — Uses `firebase_auth`, `cloud_firestore`, and `firebase_storage`.
* 📊 **Dashboard Views** — Each user role has unique navigation and actions.
* 🧠 **Provider Architecture** — State management using Provider.
* 🧾 **Seeded Test Accounts** — Predefined admin, doctor, and patient accounts for testing.
* 🌐 **Multi-Platform Support** — Works on Android, iOS, Web, Windows, macOS, and Linux.

---

## 🧩 Tech Stack

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Authentication, Firestore, Storage)
* **State Management:** Provider
* **Platforms Supported:** Android, iOS, Web, Windows, macOS, Linux

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK installed
* Firebase project configured
* Device/emulator or web browser available

### Run the App

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Build for Web

```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 🔥 Firebase Setup

1. Create a Firebase project from the [Firebase Console](https://console.firebase.google.com/).
2. Register your platforms (Android, iOS, Web).
3. Use **FlutterFire CLI** to generate `lib/firebase_options.dart`.
4. Initialize Firebase in `main.dart`:

   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

---

## 🧪 Test Accounts

| Role    | Email                                             | Password    |
| ------- | ------------------------------------------------- | ----------- |
| Admin   | [admin@hospital.com](mailto:admin@hospital.com)   | Admin@123   |
| Doctor  | [doctor@hospital.com](mailto:doctor@hospital.com) | Doctor@123  |
| Patient | [patient@example.com](mailto:patient@example.com) | Patient@123 |

*(These accounts are auto-seeded using `lib/services/database_initializer.dart`.)*

---

## 🧱 Project Structure

```
lib/
 ├─ main.dart
 ├─ providers/
 │   └─ auth_provider.dart
 ├─ screens/
 │   ├─ admin/
 │   ├─ doctor/
 │   ├─ patient/
 ├─ services/
 │   ├─ database_initializer.dart
 ├─ form_validator.dart
```

---

## 🩺 Common Issues

* **White screen on web:** Check `web/index.html` for correct Firebase SDK setup.
* **Missing assets:** Ensure paths in `pubspec.yaml` are correct and case-sensitive.
* **Provider errors:** Confirm `AuthProvider` is wrapped at the app root.

---

## 🤝 Contributing

Contributions are welcome!
Fork the repository, make improvements, and submit a pull request with clear commit messages.

---

## ⚖️ License

This project is released under the **MIT License** — free for both personal and commercial use.

---

## 📫 Contact

**Creator:** Hussain Raza Khan
**Email:** [HussainRazaKhanBaloch@gmail.com](mailto:HussainRazaKhanBaloch@gmail.com)
**GitHub:** [HusineRzaKhan](https://github.com/HusineRzaKhan)
