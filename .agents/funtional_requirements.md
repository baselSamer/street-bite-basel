# Flutter Food Ordering App — Functional Requirements

## 1. Project Overview

Develop a fully functional Flutter food ordering application that integrates Firebase, REST APIs, state management using BLoC/Cubit, local caching, localization, and device features.

Implement all mandatory requirements and the specified design patterns. Bonus features should be implemented where feasible.

---

## 2. Functional Requirements

### 2.1. Onboarding, Login, and Sign Up

**Requirements:**

- Display a splash/onboarding screen with a fade-in animation.
- Implement a sign-up form with the following validation rules:
  - **Full Name:** Must begin with a capital letter.
  - **Email:** Must be a valid email address.
  - **Password:** Minimum of six characters.
  - **Confirm Password:** Must match the password.
- Integrate Firebase Authentication for login and registration.
- Display user-friendly messages for Firebase authentication errors.
- Persist authentication state across application restarts.
- Implement the User model using the **Builder Design Pattern**.
- Manage authentication state using **AuthCubit**.

### 2.2. Home Screen and Live Menu

**Requirements:**

- Use `MediaQuery` to implement a responsive layout.
- Display featured meals using a `PageView` banner.
- Fetch meal data from **TheMealDB API** using **Dio**.
- Handle API states appropriately:
  - Loading state.
  - Successful data retrieval.
  - Error state with a user-friendly message.
- Cache meal data locally using `shared_preferences`.
- Restore cached meals when the application restarts.
- Display meals in a two-column `GridView`.

Each meal card must include:

- Meal image.
- Meal name.
- Meal category.
- Add-to-Cart button.

**Cart Interaction:**

- Dispatch Add-to-Cart events to `CartBloc`.
- Display a `SnackBar` confirming the action.

**Additional Home Screen Features:**

- Display a horizontal **Hot Offers** list containing five items.
- Implement a light/dark theme toggle managed by `ThemeBloc`.
- Use the **Factory Design Pattern** in `MealRepository` to select between remote and cached data sources.

### 2.3. Meal Details and Favourites

**Requirements:**

- Navigate to the meal details screen when a meal card is selected.
- Pass the selected meal through navigation arguments.
- Display the following information:
  - Meal image.
  - Meal name.
  - Category.
  - Origin area.
  - Cooking instructions.
- Allow users to add the selected meal to their cart using `CartBloc`.
- Use `BlocConsumer` to:
  - Display the live cart item count.
  - Provide feedback when items are added.
- Allow users to save meals to their favourites.
- Persist favourites in the currently authenticated user's Firestore document.

### 2.4. Cart and Orders

**Cart Requirements:**

- Use `BlocBuilder` to display cart items.
- Allow users to remove items from the cart.
- Recalculate and update the total price reactively.
- Use `BlocListener` to display a `SnackBar` when the cart becomes empty.

**Order Requirements:**

- Allow users to place orders.
- Save successfully placed orders to Firebase Firestore.
- Clear the cart after an order is successfully saved.

**Payment Architecture:**

Apply **SOLID principles** to payment handling:

- Define a common payment interface.
- Create a separate cash payment implementation.
- Create a separate card payment implementation.
- Ensure payment implementations can be extended without modifying existing payment-handling logic.

### 2.5. Vendor Map — BONUS

**Requirements:**

- Create a full-screen Google Maps page.
- Set the screen title to **"Nearby Vendors"**.
- Add at least five hardcoded vendor locations across different cities.
- Display markers for each vendor.

Each marker's info window must include:

- Vendor name.
- Cuisine type.
- Vendor rating.

### 2.6. Profile and Device Features

**Profile Requirements:**

- Display the authenticated user's:
  - Profile photo.
  - Full name.
  - Email address.
- Allow users to select a profile image from their device gallery using `image_picker`.
- Upload the selected profile image and persist its reference in Firestore.
- Update the profile UI immediately after a successful image update.
- Load the user's favourites live from Firestore.
- Load the user's order history live from Firestore.

**Architecture Requirement:**

- Implement the Firestore service using the **Singleton Design Pattern**.

**Biometric Authentication — BONUS:**

- Require fingerprint authentication before opening the profile screen.

### 2.7. English and Arabic Localization

**Requirements:**

- Support both English and Arabic.
- Localize every user-visible string.
- Do not hardcode text directly into UI widgets.
- Provide an in-app language toggle to switch between English and Arabic at runtime.
- Ensure the interface correctly handles both languages.
- Remove unused ARB localization entries before submission.

### 2.8. Beta Distribution

**Requirements:**

- Build a release APK of the completed application.
- Upload the APK to **Firebase App Distribution**.
- Add at least two tester email addresses.
- Verify that distribution completes successfully.
- Document the distribution process in `README.md`.
- Include screenshots demonstrating the distribution process and successful result.

---

## 3. Required Technologies

| Category           | Technology                 |
| ------------------ | -------------------------- |
| Framework          | Flutter / Dart             |
| Authentication     | Firebase Authentication    |
| Database           | Cloud Firestore            |
| API Client         | Dio                        |
| External API       | TheMealDB                  |
| State Management   | BLoC / Cubit               |
| Local Caching      | shared_preferences         |
| Maps               | Google Maps Flutter        |
| Image Selection    | image_picker               |
| Biometrics (Bonus) | local_auth                 |
| Localization       | Flutter Localization / ARB |
| Beta Distribution  | Firebase App Distribution  |

---

## 4. Required Design Patterns and Principles

The following patterns and principles are mandatory:

| Pattern / Principle | Implementation                                    |
| ------------------- | ------------------------------------------------- |
| Builder Pattern     | User model                                        |
| Factory Pattern     | MealRepository remote/cache data source selection |
| Singleton Pattern   | Firestore service                                 |
| SOLID Principles    | Payment handling                                  |
| Cubit               | Authentication and theme management               |
| BLoC                | Cart state management                             |
| BlocBuilder         | Reactive cart rendering                           |
| BlocListener        | Cart-empty notifications                          |
| BlocConsumer        | Meal details cart updates and feedback            |

---

## 5. Implementation Guidelines for the Agent

1. Implement all mandatory functional requirements.
2. Implement bonus requirements where feasible, without compromising mandatory features.
3. Follow Flutter and Dart best practices.
4. Maintain a clean, modular, and maintainable project structure.
5. Separate UI, business logic, data models, repositories, and services appropriately.
6. Use the specified BLoC/Cubit architecture consistently.
7. Implement the required design patterns in their designated components.
8. Provide loading, success, empty, and error states where applicable.
9. Handle Firebase and network errors gracefully.
10. Ensure data associated with a user is linked to the currently authenticated account.
11. Ensure Firestore updates are reflected in the UI without requiring manual refreshes.
12. Avoid hardcoded UI strings; use localization resources.
13. Ensure the application works across different screen sizes.
14. Preserve existing working functionality when modifying the project.
15. Do not introduce unnecessary dependencies or unrelated features.
16. Verify functionality through appropriate testing before considering a feature complete.
17. Do not claim successful Firebase deployment or distribution without verifying it.

---

## 6. Final Deliverables

The completed project must include:

- A functioning Flutter application covering all mandatory requirements.
- Firebase Authentication integration.
- Cloud Firestore integration for user data, favourites, and orders.
- Meal retrieval using TheMealDB and Dio.
- Local meal caching.
- Working cart and checkout functionality.
- English and Arabic localization.
- Required BLoC/Cubit implementations.
- Required design patterns and SOLID-based payment architecture.
- Bonus features where implemented.
- A release APK.
- Firebase App Distribution setup with at least two testers.
- An updated `README.md` containing:
  - Project overview.
  - Setup instructions.
  - Required Firebase configuration.
  - Instructions for running the application.
  - Release APK build instructions.
  - Firebase App Distribution documentation.
  - Screenshots demonstrating successful distribution.

**Completion Criteria:** Every mandatory requirement must be implemented and verified. Any unfinished requirement, external configuration dependency, or blocked deployment step must be explicitly documented rather than reported as complete.
