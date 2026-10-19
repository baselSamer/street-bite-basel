# StreetBite V1.0

StreetBite is a Flutter food ordering app with Firebase sign in, a live meal menu from TheMealDB, favourites, cart and cash checkout, order history, profile photos, and a Google Maps vendor page. It supports English and Arabic plus light and dark themes.

## Architecture

`lib/domain` contains entities, repository contracts, and use cases. `lib/data` contains API, cache, Firebase, and device implementations. `lib/presentation` contains screens, widgets, and Bloc/Cubit state. `lib/injection.dart` wires dependencies. TheMealDB feeds the menu, SharedPreferences caches it, and Firebase Authentication, Firestore, and Storage support accounts, orders, favourites, and photos.

## Setup

1. Install Flutter and a compatible JDK (JDK 21 works with the current Gradle wrapper).
2. In this directory, run `flutter pub get`.
3. Run `flutterfire configure` with your Firebase project to generate the local `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`. These generated configuration files are excluded from the public repository. Enable Firebase Authentication, Firestore, and Storage. Review `firestore.rules` and `storage.rules` before deploying rules.
4. Enable Maps SDK for Android and iOS for your Google Maps API key. Keep the key out of Git. On Android, set `MAPS_API_KEY=<key>` in `android/local.properties`, or put `google_maps=<key>` in the workspace root `.env`. On iOS, create ignored `ios/Flutter/MapsConfig.xcconfig` with `MAPS_API_KEY = <key>`.
5. Run `flutter run` from this directory.

Android uses Internet and biometric permissions. iOS requests photo library, camera, and Face ID access when those features are used. Biometric profile unlock is offered on devices with enrolled biometrics.

## Verification and beta

`dart format .`, `dart analyze lib test`, and `flutter test` were run during development. The release APK was built with `flutter build apk --release`. The APK was distributed through Firebase App Distribution to two confirmed testers on 19 October 2026. Release ID: `1t9f4de65vodg`. [Firebase App Distribution release](https://console.firebase.google.com/project/streetbite-1b333/appdistribution/app/android:com.example.street_bite_test/releases/1t9f4de65vodg).

The release APK is a beta build signed with the debug keystore. Configure a dedicated release signing key before store publication. Cash checkout is available; the card payment adapter has no payment gateway connection. Exact screen matching to the referenced Figma kit still needs a visual review of exported design screens.
