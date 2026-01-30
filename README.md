# Stride

> A lightweight cross-platform To‑Do app built with Flutter.

A minimal to‑do manager with local persistence and light/dark theme support. Organize your tasks across Android, iOS, Web, Linux, macOS, and Windows.

## Installation & Setup

### Prerequisites

Ensure you have the following installed:
- **Flutter SDK** (stable or latest) — [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (comes with Flutter)
- **Android SDK** (for Android) or **Xcode** (for iOS on macOS)
- An emulator, simulator, or physical device (optional, but recommended for testing)

### Get Started

1. **Clone & enter the project:**
   ```bash
   cd stride
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Check your environment:**
   ```bash
   flutter doctor
   ```
   This ensures your Flutter setup is ready.

4. **Run the app:**
   ```bash
   flutter run
   ```
   Or specify a target device:
   ```bash
   flutter devices  # list available devices
   flutter run -d <device-id>
   ```

## Building for Different Platforms

- **Debug (Android/iOS):**
  ```bash
  flutter run
  ```

- **Release APK (Android):**
  ```bash
  flutter build apk --release
  ```

- **iOS (macOS required, Xcode setup needed):**
  ```bash
  flutter build ios --release
  ```

- **Web:**
  ```bash
  flutter build web
  ```

- **Desktop (Linux/macOS/Windows):**
  ```bash
  # Enable platform if needed
  flutter config --enable-windows
  flutter build windows --release
  ```

## Platform-Specific Setup

### Android
- Ensure `local.properties` points to your Android SDK path.
- Have an emulator running or a physical device connected via USB with debugging enabled.
- Check Android toolchain: `flutter doctor -v`

### iOS
- Requires macOS and Xcode installed.
- After updating pubspec, run:
  ```bash
  cd ios && pod install --repo-update && cd ..
  ```
- Open the workspace in Xcode and configure signing if deploying to a device.

### Desktop (Linux/macOS/Windows)
- Enable the platform first:
  ```bash
  flutter config --enable-linux
  flutter config --enable-macos
  flutter config --enable-windows
  ```
- Linux: ensure build-essential and other dev packages are installed.
- macOS/Windows: follow platform-specific setup from `flutter doctor`.

## Features

- ✅ **Add, edit, and delete to‑do items** — Manage your tasks easily.
- 💾 **Local persistence** — Data is stored locally using SQLite (see [lib/services/todo_database.dart](lib/services/todo_database.dart)).
- 🎨 **Light & Dark themes** — Toggle themes via [lib/providers/theme_provider.dart](lib/providers/theme_provider.dart).
- 📱 **Cross-platform** — Runs on Android, iOS, Web, Linux, macOS, and Windows.

## Project Structure

```
stride/
├── lib/                          # Application source
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   └── todo.dart
│   ├── providers/                # State management
│   │   └── theme_provider.dart
│   ├── services/                 # Business logic & persistence
│   │   ├── todo_database.dart    # SQLite database
│   │   └── to_do_adapter.dart
│   └── UI/                       # Screens & widgets
│       ├── home_screen.dart
│       └── add_to_dialog.dart
├── android/                      # Android project
├── ios/                          # iOS project
├── web/                          # Web project
├── linux/ macos/ windows/        # Desktop projects
├── test/                         # Unit & widget tests
├── pubspec.yaml                  # Dependencies & config
└── README.md                     # You are here
```

## Development

### Code Quality
- **Format code:**
  ```bash
  dart format .
  ```

- **Run linter & analyzer:**
  ```bash
  flutter analyze
  ```

- **Run tests:**
  ```bash
  flutter test
  ```

### Key Files to Explore
| File | Purpose |
|------|---------|
| [lib/main.dart](lib/main.dart) | App entry point & app configuration |
| [lib/UI/home_screen.dart](lib/UI/home_screen.dart) | Main UI and to-do list display |
| [lib/services/todo_database.dart](lib/services/todo_database.dart) | SQLite persistence logic |
| [lib/providers/theme_provider.dart](lib/providers/theme_provider.dart) | Theme state management |
| [pubspec.yaml](pubspec.yaml) | Dependencies & Flutter config |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Missing packages | `flutter pub get` or `flutter pub upgrade` |
| iOS build fails | `cd ios && pod install --repo-update && cd ..` |
| Platform not found | `flutter config --enable-<platform>` (e.g., `--enable-windows`) |
| Device not detected | `flutter doctor -v` and check USB/emulator setup |
| Hot reload not working | Try `flutter clean` and `flutter run` again |
| Dart analysis errors | Run `dart fix --apply` to auto-fix issues |

## Contributing

We welcome bug reports and pull requests! Please:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/my-feature`).
3. Commit your changes (`git commit -am 'Add my feature'`).
4. Push to the branch (`git push origin feature/my-feature`).
5. Open a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

