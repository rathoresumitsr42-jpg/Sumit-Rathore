import 'dart:async';

abstract class AuthService {
  Future<bool> login(String email, String password);
  Future<bool> loginWithPin(String pin);
  Future<void> signOut();
  bool get isLoggedIn;
  String? get currentUserEmail;
  String? get currentUserName;
}

class MockAuthService implements AuthService {
  bool _isLoggedIn = false;
  String? _currentUserEmail;
  String? _currentUserName;

  @override
  Future<bool> login(String email, String password) async {
    // Simulate API network latency
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Accept proprietor's email from metadata
    if ((email.toLowerCase() == 'rathoresumit.sr42@gmail.com' || email.toLowerCase() == 'admin@sr.com') && 
        password == 'admin123') {
      _isLoggedIn = true;
      _currentUserEmail = email;
      _currentUserName = "Sumit Rathore";
      return true;
    }
    return false;
  }

  @override
  Future<bool> loginWithPin(String pin) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (pin == '2026') {
      _isLoggedIn = true;
      _currentUserEmail = 'rathoresumit.sr42@gmail.com';
      _currentUserName = "Sumit Rathore";
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    _currentUserEmail = null;
    _currentUserName = null;
  }

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  String? get currentUserEmail => _currentUserEmail;

  @override
  String? get currentUserName => _currentUserName;
}
