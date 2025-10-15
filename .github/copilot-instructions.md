# CalmConnect Flutter App - AI Coding Instructions

## Project Overview
CalmConnect is a mental health support Flutter app with Firebase backend, using GetX for state management. The app facilitates peer-to-peer communication, professional resource discovery, and daily wellness tips.

## Architecture & Patterns

### State Management - GetX Pattern
- All controllers extend `GetxController` and use `update()` for UI refresh
- Dependency injection via `Appbinding` class in `lib/app_binding/app_binding.dart`
- Controllers registered as lazy singletons with `fenix: true` for persistence
- Access controllers with `Get.find<ControllerName>()`

Example controller structure:
```dart
class HomeProvider extends GetxController {
  List<Tip> _tips = [];
  
  List<Tip> get tips => _search.isEmpty ? _tips : filteredResults;
  
  void addTip(Tip tip) {
    _tips.insert(0, tip);
    update(); // Required for UI refresh
  }
}
```

### Navigation System
- Custom route generator in `lib/routes/route_generator.dart`
- Route constants defined in `lib/routes/routes.dart`
- Platform-specific transitions: `CupertinoPageRoute` for iOS, `FadeRoute` for Android
- Arguments passed via `RouteSettings.arguments` as `Map<String, dynamic>`

### Firebase Integration
- Firebase Auth for authentication (`lib/controller/auth_controller.dart`)
- Firestore for real-time chat and user data (`lib/service/firebase_service.dart`)
- Chat rooms use deterministic IDs: sorted user UIDs joined with underscore
- All Firebase operations are async and include error handling
- User types: `UserType.peer` for regular users, `UserType.counsellor` for professionals

### Widget Architecture
- Reusable components in `lib/component/` (e.g., `KTextFormField`)
- Screen-specific widgets in `lib/screens/[screen]/widgets/`
- Material Design 3 theming with `Theme.of(context).colorScheme`
- Responsive layouts using `LayoutBuilder` and adaptive grid systems

## Key Development Workflows

### Authentication Flow
- App checks `FirebaseAuth.instance.currentUser` on startup
- Routes to `/auth` if not logged in, `/` (home) if authenticated
- `AuthController` handles sign up/in with email/password
- Users choose account type during registration (peer/counsellor)

### Adding New Screens
1. Create screen folder: `lib/screens/[name]/`
2. Structure: `view/`, `controller/`, `widgets/`
3. Register controller in `app_binding.dart`
4. Add route to `routes.dart` and `route_generator.dart`
5. Use `GetBuilder<Controller>` widgets for reactive UI

### Firebase Chat Implementation
- Collection structure: `chats/{chatRoomId}/messages/{messageId}`
- Real-time listening with `StreamBuilder<QuerySnapshot>`
- Message ordering by timestamp with `orderBy('timestamp', descending: true)`
- Auto-scroll to bottom after sending messages

### Custom Components
- Use consistent Material 3 styling patterns
- Implement `onTap` callbacks for all interactive elements
- Follow existing component patterns in `lib/component/`
- Use `Theme.of(context).colorScheme` for colors, never hardcoded values

## Data Models
- Simple data classes with required parameters (no serialization)
- Models in `lib/model/` follow pattern: `class_name.dart`
- Use factories for mock data generation (see `mockTips()`, `mockResources()`)

## Common Gotchas
- Always call `update()` in GetX controllers after state changes
- Chat room IDs must be deterministic for consistent message threading  
- Use `SafeArea` wrapper for all main screen content
- Firebase operations need null safety and error handling
- Platform-specific imports: prefer conditional imports over platform checks

## Testing & Debugging
- Run tests: `flutter test`
- Firebase emulator for local development
- Use `flutter analyze` for lint checking
- Debug chat: check Firestore console for message structure