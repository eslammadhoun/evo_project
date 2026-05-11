import 'package:evo_project/core/services/app_preferences.dart';

class UserSession {
  final AppPreferences appPreferences;
  UserSession({required this.appPreferences});

  String? get token => appPreferences.getToken();
  String? get name => appPreferences.getUserName();
  String? get email => appPreferences.getUserEmail();
  bool get isAuthenticated => appPreferences.isAuthenticated();
}
