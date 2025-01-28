import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _userId = ''; // Default empty userId
  String _userName = '';

  String get userId => _userId;
  String get userName => _userName;

  // This function should be called when user logs in or data is fetched
  void setUser(String userId, String userName) {
    _userId = userId;
    _userName = userName;
    notifyListeners();
  }

  // Reset the user data when logged out
  void logout() {
    _userId = '';
    _userName = '';
    notifyListeners();
  }
}
