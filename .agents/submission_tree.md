## Expected Submission Structure

The final project must follow the directory structure below (unless additional files were included initially, they can stay, but you still need to follow this structure):

```text
streetbite-capstone/
└── flutter_app/
    ├── lib/
    │   ├── main.dart
    │   ├── injection.dart
    │   ├── core/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   ├── presentation/
    │   │   ├── blocs/
    │   │   ├── screens/
    │   │   └── widgets/
    │   └── l10n/
    │       ├── app_en.arb
    │       └── app_ar.arb
    ├── pubspec.yaml
    └── README.md
```

### Directory Responsibilities

| Directory / File        | Responsibility                                                                 |
| ----------------------- | ------------------------------------------------------------------------------ |
| `main.dart`             | Application entry point, initialization, and startup configuration.            |
| `injection.dart`        | Dependency injection and service registration.                                 |
| `core/`                 | Shared utilities, constants, error handling, themes, and common functionality. |
| `data/datasources/`     | Remote and local data sources, including APIs, Firebase, and caching.          |
| `data/models/`          | Data models, serialization, and deserialization.                               |
| `data/repositories/`    | Concrete repository implementations.                                           |
| `domain/entities/`      | Core business entities independent of external frameworks.                     |
| `domain/repositories/`  | Abstract repository contracts.                                                 |
| `domain/usecases/`      | Application-specific business operations.                                      |
| `presentation/blocs/`   | BLoC/Cubit classes, events, and states.                                        |
| `presentation/screens/` | Application screens and page layouts.                                          |
| `presentation/widgets/` | Reusable UI components.                                                        |
| `l10n/`                 | Localization resources for English and Arabic.                                 |
| `pubspec.yaml`          | Flutter dependencies, assets, and project configuration.                       |
| `README.md`             | Setup instructions, documentation, and distribution evidence.                  |

### Instructions for the Agent

1. Follow the specified directory structure and maintain clear separation of concerns.
2. Organize implementations into the appropriate architectural layers.
3. Keep business logic out of UI widgets whenever possible.
4. Use dependency injection to connect services, repositories, and state management components.
5. Keep repository interfaces in `domain/repositories/` and their implementations in `data/repositories/`.
6. Keep API, Firebase, and local storage logic inside the data layer.
7. Place shared UI components inside `presentation/widgets/`.
8. Organize BLoCs and Cubits by feature inside `presentation/blocs/`.
9. Keep English and Arabic localization files inside `lib/l10n/`.
10. Additional files and subdirectories may be created as needed, but the required architectural structure must be preserved.
11. Retain standard Flutter platform directories and configuration files required for building and running the application.

**Important:** The provided tree represents the required architectural structure, not an exhaustive list of every file in the Flutter project. Do not delete necessary Flutter-generated files or platform-specific directories to match the tree exactly.
