# Ramani Mobile App

This is the Flutter mobile frontend for the Ramani campus navigation project.

## Setup

1. Install Flutter SDK:
   - https://flutter.dev/docs/get-started/install

2. Install dependencies:
   ```bash
   cd mobile
   flutter pub get
   ```

3. Run the app on emulator or device:
   ```bash
   flutter run
   ```

## Features

- **Location Recording**: Automatically detect current GPS coordinates when recording campus blocks
- **Manual Override**: Can still manually enter coordinates if needed
- **Block Information**: Record block names, labels, and descriptions

## Permissions

The app requires location permissions to automatically detect coordinates:

- **Android**: ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION
- **iOS**: Location services when in use

Make sure to grant location permissions when prompted.
