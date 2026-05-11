# 🛍️ Nectar EVO (Flutter E-Commerce App)

A production-oriented Flutter e-commerce application built with a feature-first, Clean Architecture-inspired codebase.  
The project emphasizes maintainable architecture, scalable state management, secure session handling, and reusable UI systems.

---

## ✨ Overview

Nectar EVO is a mobile shopping app that includes authentication, product discovery, product details, cart and wishlist management, notifications, and profile capabilities.

The engineering focus is not only feature delivery, but also:
- architectural separation of concerns,
- predictable state flows,
- local persistence for key user flows,
- and reusable component-driven UI.

---

## 🚀 Key Features

- 🔐 Authentication: login, registration, logout, token refresh bootstrap
- 🏠 Dashboard: promotional banners + featured products
- 🧭 Catalog navigation: category products with incremental loading
- 📦 Product details: image gallery, size selection, quantity handling, related products
- 🛒 Cart: add/remove/update quantity, promo code logic, checkout page
- ❤️ Wishlist: optimistic toggling with rollback on failure
- 🔔 Notifications: local push display + local notifications storage
- 👤 Profile flow with image upload support path
- 🧱 Reusable design-system-style widgets across screens

---

## 🧠 Architecture

The app follows a feature-first, Clean Architecture-inspired structure:

`Presentation (BLoC/UI) -> Domain (UseCases/Entities/Repository Contracts) -> Data (DataSources/Models/Mappers/Repository Implementations)`

### Why this architecture?
- Keeps business logic testable and isolated from UI
- Makes data source changes safer (API/local DB evolution)
- Enables team scalability via clear module boundaries

---

## 🗂️ Folder Structure

```text
lib/
├── core/
│   ├── di/                  # GetIt service locator
│   ├── router/              # go_router route graph + shell navigation
│   ├── network/             # Dio client, interceptors, endpoints, wrappers
│   ├── services/            # preferences, auth event stream, notifications
│   ├── Database/            # sqflite provider, tables, DB abstraction
│   ├── shared/widgets/      # reusable UI components
│   ├── errors/              # Failure models + repository error handling
│   ├── theme/               # color/typography/theme system
│   └── helpers/             # cache manager, request helpers, formatters
├── features/
│   ├── auth/
│   ├── home/
│   ├── cart/
│   ├── wishlist/
│   └── notifications/
└── main.dart                # app bootstrap, DI init, global providers
```

---

## 🧩 State Management

State management is implemented with `flutter_bloc`:
- Feature-specific BLoCs manage isolated state domains
- Root-level `MultiBlocProvider` wires app-level BLoCs
- Event/state-driven flow improves predictability
- `BlocSelector` and selective rebuild usage reduce rendering overhead in key widgets

---

## 🛠️ Tech Stack

| Category | Package / Tool | Usage in Project |
|---|---|---|
| Framework | `Flutter` (`Dart 3.x`) | Core mobile app framework and language runtime |
| Architecture & DI | `get_it` | Service locator for repositories, use-cases, and BLoCs |
| State Management | `flutter_bloc` | Event/state-driven feature state management |
| Navigation | `go_router` | Route graph + tab shell via `StatefulShellRoute.indexedStack` |
| Networking | `dio` | API client with custom interceptors and failure mapping |
| Local Database | `sqflite` | Persistent storage for cart, wishlist, and notifications |
| Secure Session Storage | `flutter_secure_storage` | Encrypted token storage |
| App Preferences | `shared_preferences` | Lightweight flags and user/app preferences |
| Error Modeling | `dartz` (`Either`) | Functional success/failure result handling |
| Image Caching | `cached_network_image` + `flutter_cache_manager` | Network image rendering and cache policy |
| Local Notifications | `flutter_local_notifications` | In-app local notification delivery |
| Environment Config | `flutter_dotenv` | Runtime environment variable loading |

---

## 🔐 Security Practices

- Secure token storage via `flutter_secure_storage`
- In-memory token cache to support synchronous interceptor auth headers
- Android network security config with cleartext disabled
- iOS ATS pinned domain configuration
- 401 handling via global auth event stream and forced sign-out redirect

> Note: The project currently ships `.env.prod` as an asset; sensitive keys should be moved to a safer strategy (server-side proxy/runtime secure config).

---

## 🌐 API and Data Layer

- Endpoints are centralized in `core/network/api_endpoints.dart`
- `ApiClient` wraps Dio requests and maps networking failures to app-level `Failure` objects
- Repositories encapsulate datasource calls and return domain-friendly `Either<Failure, T>` in most flows
- Mappers are used to convert API models into domain entities

---

## 💾 Offline Support

Current offline behavior is partial:
- Cart, wishlist, and notifications persist locally with sqflite
- Remote catalog/auth flows still rely on live API availability
- No full offline-first sync queue exists yet

---

## 🎨 UI/UX and Reusable Components

- Shared widget library for buttons, text fields, headers, nav bar, product cards, loaders, etc.
- Consistent theming and typography abstraction in `core/theme`
- Smooth micro-interactions via `AnimatedCrossFade`, `AnimatedSwitcher`, `AnimatedOpacity`, and other Animated widgets
- Manual responsive layout patterns with `MediaQuery`, `LayoutBuilder`, and size extensions

---

## 🧭 Navigation Design

- `go_router` is used for route orchestration
- Bottom tabs are implemented with `StatefulShellRoute.indexedStack` for stateful branch navigation:
  - Home
  - Search
  - Cart
  - Wishlist
  - Profile
- Product details route creates a scoped `ProductDetailsBloc` instance per product

---

## 🧪 Testing Status

- Testing scaffolding exists, but automated coverage is currently minimal
- Recommended next step: unit tests for use-cases/repositories + bloc tests + golden tests for shared widgets

---

## 📸 Screenshots

Add actual screenshots/GIFs here before publishing.

- Splash / Onboarding
- <img width="828" height="1792" alt="IMG_0815" src="https://github.com/user-attachments/assets/28c894a5-6f68-4dda-8c68-bb2287f3a5b0" />

- Sign In / Sign Up
- Home Dashboard
- Product Listing
- Product Details
- Cart & Checkout
- Wishlist
- Notifications
- Profile

---

## ⚙️ Installation

### Prerequisites
- Flutter SDK (matching project constraints)
- Dart SDK (as required by Flutter)
- Xcode (for iOS), Android Studio (for Android)

### Setup
```bash
git clone <your-repo-url>
cd evo_project
flutter pub get
```

### Environment
Create the environment file expected by the app:
- `.env.prod` (currently loaded at startup)

Expected keys:
```env
BASE_URL=...
IMAGE_API_KEY=...
```

---

## ▶️ Run the App

```bash
flutter run
```

### Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🔥 Firebase Setup

Firebase is not currently integrated in this codebase.

If added in the future:
- Add `firebase_core` and required packages
- Configure `google-services.json` and `GoogleService-Info.plist`
- Initialize Firebase in `main.dart`

---

## 🧱 Engineering Decisions and Trade-offs

### What was done well
- Feature-first modular architecture
- Clear BLoC-driven state boundaries
- Strong local persistence integration for commerce-critical local flows
- Centralized DI and network layers
- Reusable UI component system

### Known trade-offs / current limitations
- Some layer boundary leaks (domain/presentation touching data-layer types)
- Inconsistent naming/casing across old/new folders
- Partial offline support (not yet offline-first)
- API response envelope parsing can be hardened for consistency
- Secrets handling strategy needs production hardening

---

## 📈 Scalability Notes

This architecture is ready to scale with:
- additional features via module cloning pattern
- stronger contract tests at repository/use-case levels
- guarded route middleware and richer session handling
- gradual replacement of service-locator lookups in UI with stricter injection boundaries

---

## 🧭 Challenges Solved

- Managing complex app state across multiple feature modules with independent BLoCs
- Keeping cart/wishlist/notifications resilient through local database persistence
- Handling session expiry globally through interceptor + auth event stream
- Building reusable widgets and animation primitives without over-coupling feature modules

---

## 🛣️ Future Improvements

- Add comprehensive automated testing strategy (unit/bloc/widget/golden)
- Introduce route guards via declarative `go_router` redirects
- Implement robust token refresh-and-retry queue in interceptors
- Harden secrets management (remove sensitive runtime values from bundled assets)
- Improve offline-first behavior with cache fallbacks and sync queues
- Normalize naming conventions and remove cross-layer coupling hotspots

---

## 💼 Why This Project Is Technically Strong

- It demonstrates practical, production-relevant architecture decisions
- It balances feature delivery with long-term maintainability patterns
- It includes security-aware and persistence-aware engineering choices
- It shows real-world Flutter competency: DI, routing, BLoC orchestration, local DB, networking, error modeling, and reusable UI systems

---

## 📄 License

Add your preferred license (`MIT`, `Apache-2.0`, etc.).
