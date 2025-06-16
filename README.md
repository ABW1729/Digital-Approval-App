# 📲 Digital Approval System

A full-featured **Flutter mobile application** designed to digitize and streamline institutional approval workflows. Built for Android with real-time updates, request tracking, and dynamic multi-level approval logic to support both academic and administrative processes.

---

## 🚀 Features

- ✅ Multi-level approval system (dynamic routing)
- 🔄 Real-time updates and communication via **Socket.IO**
- 📦 Backend integration with **PostgreSQL**
- 🔔 Status tracking and notifications
- 🧑‍💼 Role-based request visibility (admin, faculty, staff)

---

## 🛠️ Tech Stack

| Layer       | Tech                             |
|-------------|----------------------------------|
| Frontend    | Flutter                          |
| Backend     | Node.js + Express                |
| Database    | PostgreSQL                       |
| Real-time   | Socket.IO                        |

---

## 📦 Dependencies (Flutter)

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.6
  provider: ^6.1.1
  socket_io_client: ^2.0.3+1
  flutter_local_notifications: ^15.1.0
  shared_preferences: ^2.2.2
  fluttertoast: ^8.2.4
```

You may also include:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

## 🧑‍💻 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/digital-approval-system.git
cd digital-approval-system
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

> Make sure an Android device/emulator is connected.



---

## 📄 License

This project is licensed under the MIT License.
