flutter build apk --split-per-abi

flutter clean
flutter pub get
flutter pub run flutter_native_splash:create

flutter pub get
flutter pub run flutter_launcher_icons:main

keytool -genkey -v -keystore c:\Users\SHRI\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

# noteapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
