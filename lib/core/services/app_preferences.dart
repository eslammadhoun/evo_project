import 'package:evo_project/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

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

  // --- Specific Methods ---

  // Auth Token
  String? getToken() => _prefs.getString(AppConstants.authTokenKey);
  Future<bool> setToken(String token) =>
      _prefs.setString(AppConstants.authTokenKey, token);

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

  // Logout
  Future<void> logout() async {
    await remove(AppConstants.authTokenKey);
    await remove(keyIsAuthenticated);
    await remove(keyUserName);
    await remove(keyUserEmail);
    // Note: We typically don't clear onboarding status on logout
  }
}
