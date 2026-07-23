import 'dart:convert';

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
  static const _userIdKey = 'auth_user_id';
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

  // ─── User id (for scoping local Results) ───

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    final stored = await _secureStorage.read(key: _userIdKey);
    if (stored != null && stored.isNotEmpty) return stored;

    // Backward compatible: older sessions only stored the JWT.
    final fromToken = await _userIdFromToken();
    if (fromToken != null && fromToken.isNotEmpty) {
      await saveUserId(fromToken);
      return fromToken;
    }
    return null;
  }

  Future<String?> _userIdFromToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final normalized = base64Url.normalize(parts[1]);
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized)))
              as Map<String, dynamic>;
      return payload['id']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUserId() async {
    await _secureStorage.delete(key: _userIdKey);
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
      await deleteUserId();
    }
  }

  /// Full session cleanup — used on logout and 401/403 forced logout.
  Future<void> clearSession() async {
    await deleteToken();
    await deleteUserId();
    await _prefs.remove(_rememberMeKey);
  }
}
