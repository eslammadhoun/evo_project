import 'dart:async';

/// Global auth event bus
/// Used to notify app when user becomes unauthenticated (401 / logout / token expired)
class AuthSignals {
  AuthSignals._(); // منع إنشاء instances

  /// Stream to notify that user must be logged out
  static final StreamController<void> unauthenticated =
      StreamController<void>.broadcast();

  /// Trigger logout event
  static void triggerLogout() {
    if (!unauthenticated.isClosed) {
      unauthenticated.add(null);
    }
  }

  /// Dispose (optional - use only if you manage lifecycle manually)
  static void dispose() {
    unauthenticated.close();
  }
}
