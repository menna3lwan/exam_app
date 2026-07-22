import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages auth token persistence and Remember Me state.
///
/// Token is stored in flutter_secure_storage (AES-encrypted).
/// Remember Me flag is stored in SharedPreferences (lightweight).
///
/// ## Token lifecycle
/// - **Login/SignUp success** → [saveToken] stores the JWT.
/// - **App start** → [isLoggedIn] checks if a valid token exists
///   AND the user opted into Remember Me.
/// - **Logout / 401** → [clearSession] wipes everything.
///
/// ## Remember Me behavior
/// - Checked → token persists across app restarts → auto-login.
/// - Unchecked → token persists for current session only;
///   on next app start [clearSessionIfNotRemembered] wipes it.
class TokenService {
  static const _tokenKey = 'auth_token';
  static const _rememberMeKey = 'remember_me';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  TokenService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage,
        _prefs = prefs;

  // ─── Token operations ───

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Returns true if a token exists in secure storage.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Remember Me operations ───

  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  bool getRememberMe() {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  // ─── Session operations ───

  /// Returns true if the user should be auto-logged in:
  /// token exists AND Remember Me was checked.
  Future<bool> isLoggedIn() async {
    final rememberMe = getRememberMe();
    if (!rememberMe) return false;
    return hasToken();
  }

  /// Called on app start — if Remember Me is false, clear the stored token
  /// so the user isn't auto-logged in.
  Future<void> clearSessionIfNotRemembered() async {
    final rememberMe = getRememberMe();
    if (!rememberMe) {
      await deleteToken();
    }
  }

  /// Full session cleanup — used on logout and 401/403 forced logout.
  Future<void> clearSession() async {
    await deleteToken();
    await _prefs.remove(_rememberMeKey);
  }
}
