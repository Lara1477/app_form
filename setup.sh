#!/bin/bash
# Genera las carpetas de plataforma (android, ios, web...) y agrega el permiso de internet
flutter create . --project-name app_form
flutter pub get
MANIFEST=android/app/src/main/AndroidManifest.xml
if ! grep -q "android.permission.INTERNET" "$MANIFEST"; then
  sed -i 's|<application|<uses-permission android:name="android.permission.INTERNET"/>\n    <application|' "$MANIFEST"
fi
echo "Listo. Ejecuta: flutter run"
