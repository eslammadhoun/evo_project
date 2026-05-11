import 'package:evo_project/core/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  // In-memory token cache — keeps getToken() synchronous so that
  // AppInterceptors.onRequest() can read the token without going async.
  String? _cachedToken;

  AppPreferences(this._prefs, this._secureStorage);

  // Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyIsAuthenticated = 'is_authenticated';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyIsUserHaveDiscount = 'have_discount';
  static const String keyCartDiscount = 'cart_discount';

  // --- Generic Methods ---
  dynamic get(String key) => _prefs.get(key);

  Future<bool> setValue(String key, dynamic value) async {
    if (value is String) return await _prefs.setString(key, value);
    if (value is int) return await _prefs.setInt(key, value);
    if (value is bool) return await _prefs.setBool(key, value);
    if (value is double) return await _prefs.setDouble(key, value);
    if (value is List<String>) return await _prefs.setStringList(key, value);
    return false;
  }

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();

  // --- Auth Token (Encrypted Secure Storage + In-Memory Cache) ---

  /// Must be called once during app startup (before any network call).
  ///
  /// Reads the token from secure storage into [_cachedToken].
  /// Also migrates any token that was previously stored in plaintext
  /// SharedPreferences — so existing users are not logged out on upgrade.
  Future<void> loadToken() async {
    String? token = await _secureStorage.read(key: AppConstants.authTokenKey);

    // One-time migration: move legacy plaintext token to secure storage.
    if (token == null || token.isEmpty) {
      final legacyToken = _prefs.getString(AppConstants.authTokenKey);
      if (legacyToken != null && legacyToken.isNotEmpty) {
        await _secureStorage.write(
          key: AppConstants.authTokenKey,
          value: legacyToken,
        );
        await _prefs.remove(AppConstants.authTokenKey);
        token = legacyToken;
      }
    }

    _cachedToken = token;
  }

  /// Synchronous read from in-memory cache.
  /// Safe to call inside Dio interceptors (which cannot be async).
  String? getToken() => _cachedToken;

  /// Persists the token in secure storage and updates the in-memory cache.
  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _secureStorage.write(key: AppConstants.authTokenKey, value: token);
  }

  // Onboarding
  bool isOnboardingCompleted() =>
      _prefs.getBool(keyOnboardingCompleted) ?? false;
  Future<bool> setOnboardingCompleted(bool value) =>
      _prefs.setBool(keyOnboardingCompleted, value);

  // Authentication Status
  bool isAuthenticated() => _prefs.getBool(keyIsAuthenticated) ?? false;
  Future<bool> setAuthenticated(bool value) =>
      _prefs.setBool(keyIsAuthenticated, value);

  // User Data
  String getUserName() => _prefs.getString(keyUserName) ?? '';
  Future<bool> setUserName(String name) => _prefs.setString(keyUserName, name);

  String getUserEmail() => _prefs.getString(keyUserEmail) ?? '';
  Future<bool> setUserEmail(String email) =>
      _prefs.setString(keyUserEmail, email);

  // Get User Cart Discount
  bool userHaveDicount() => _prefs.getBool(keyIsUserHaveDiscount) ?? false;
  double getCartDiscount() => _prefs.getDouble(keyCartDiscount) ?? 0.0;
  Future<bool> setUserHavingDiscount(bool haveDiscount) =>
      _prefs.setBool(keyIsUserHaveDiscount, haveDiscount);
  Future<bool> setDiscount(double discount) =>
      setValue(keyCartDiscount, discount);

  // Logout — clears the in-memory cache and wipes token from secure storage.
  Future<void> logout() async {
    _cachedToken = null;
    await _secureStorage.delete(key: AppConstants.authTokenKey);
    await remove(keyIsAuthenticated);
    await remove(keyUserName);
    await remove(keyUserEmail);
    // Note: We typically don't clear onboarding status on logout.
  }
}
