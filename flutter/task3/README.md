# Task 3 – Delivery Locations

Fetches a list of delivery locations from a mock API and displays them in a list. Tapping any item opens a map showing the delivery address and your current location, with an option to navigate via Google Maps.

## Setup

### Google Maps API key

**Android** – `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE" />
```

**iOS** – `ios/Runner/Info.plist`:
```xml
<key>GMSApiKey</key>
<string>YOUR_KEY_HERE</string>
```

## Run

```bash
flutter pub get
flutter run
```

## Structure

```
lib/
├── main.dart
├── models/delivery_location.dart
├── services/api_service.dart
├── screens/
│   ├── delivery_list_screen.dart
│   └── map_screen.dart
└── widgets/location_list_tile.dart
assets/
└── delivery_locations.json
```
