import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _username = '';
  String _email = '';
  String _role = 'user';

  String get userId => _userId;
  String get username => _username;
  String get email => _email;
  String get role => _role;

  void setUser({
    required String userId,
    required String username,
    required String email,
    String role = 'user',
  }) {
    _userId = userId;
    _username = username;
    _email = email;
    _role = role;
    notifyListeners();
  }

  void clearUser() {
    _userId = '';
    _username = '';
    _email = '';
    _role = 'user';
    notifyListeners();
  }

  bool get isLoggedIn => _userId.isNotEmpty;
}
