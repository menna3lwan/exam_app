// TokenService is the single source of truth for the auth session:
// where the JWT lives, whether the user opted into "Remember Me", and
// what "logged in" means on app start. Every test here mocks
// FlutterSecureStorage (no real Keychain/Keystore access) and uses a
// real SharedPreferences instance backed by SharedPreferences'
// in-memory test fake, since faithfully mocking every SharedPreferences
// method adds noise without adding confidence.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exam_app/core/services/token_service.dart';

import '../../helpers/mocks.dart';

/// Builds a syntactically-valid (unsigned) JWT whose payload contains
/// the given claims — enough to exercise TokenService's own base64url
/// decode logic, which never verifies the signature itself.
String _fakeJwt(Map<String, dynamic> payload) {
  String encodeSegment(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  final header = encodeSegment({'alg': 'HS256', 'typ': 'JWT'});
  final body = encodeSegment(payload);
  return '$header.$body.fake-signature';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage secureStorage;
  late TokenService tokenService;

  setUp(() async {
    secureStorage = MockFlutterSecureStorage();
    when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => secureStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    tokenService = TokenService(secureStorage: secureStorage, prefs: prefs);
  });

  group('Token persistence', () {
    test('saveToken writes under the auth_token key', () async {
      await tokenService.saveToken('jwt-123');
      verify(() => secureStorage.write(key: 'auth_token', value: 'jwt-123')).called(1);
    });

    test('getToken returns whatever secure storage holds', () async {
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => 'jwt-123');
      expect(await tokenService.getToken(), 'jwt-123');
    });

    test('hasToken is false when no token is stored', () async {
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => null);
      expect(await tokenService.hasToken(), isFalse);
    });

    test('hasToken is false for an empty-string token', () async {
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => '');
      expect(await tokenService.hasToken(), isFalse);
    });

    test('hasToken is true for a non-empty token', () async {
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => 'jwt-123');
      expect(await tokenService.hasToken(), isTrue);
    });

    test('deleteToken removes the stored key', () async {
      await tokenService.deleteToken();
      verify(() => secureStorage.delete(key: 'auth_token')).called(1);
    });
  });

  group('User id — direct storage', () {
    test('getUserId returns the explicitly saved id without touching the token', () async {
      when(() => secureStorage.read(key: 'auth_user_id')).thenAnswer((_) async => 'user-42');

      expect(await tokenService.getUserId(), 'user-42');
      verifyNever(() => secureStorage.read(key: 'auth_token'));
    });
  });

  group('User id — backward-compatible JWT fallback', () {
    test('decodes the "id" claim from the token when no id was saved directly', () async {
      final jwt = _fakeJwt({'id': 'from-jwt-99'});
      when(() => secureStorage.read(key: 'auth_user_id')).thenAnswer((_) async => null);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => jwt);

      final userId = await tokenService.getUserId();

      expect(userId, 'from-jwt-99');
      // Backfills the id so future calls don't need to decode again.
      verify(() => secureStorage.write(key: 'auth_user_id', value: 'from-jwt-99')).called(1);
    });

    test('returns null when there is neither a saved id nor a token', () async {
      when(() => secureStorage.read(key: 'auth_user_id')).thenAnswer((_) async => null);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => null);

      expect(await tokenService.getUserId(), isNull);
    });

    test('returns null instead of throwing for a malformed token', () async {
      when(() => secureStorage.read(key: 'auth_user_id')).thenAnswer((_) async => null);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => 'not-a-jwt');

      expect(await tokenService.getUserId(), isNull);
    });

    test('returns null when the JWT payload has no "id" claim', () async {
      final jwt = _fakeJwt({'email': 'test@test.com'});
      when(() => secureStorage.read(key: 'auth_user_id')).thenAnswer((_) async => null);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => jwt);

      expect(await tokenService.getUserId(), isNull);
    });
  });

  group('Remember Me', () {
    test('defaults to false when never set', () {
      expect(tokenService.getRememberMe(), isFalse);
    });

    test('persists true/false across reads', () async {
      await tokenService.setRememberMe(true);
      expect(tokenService.getRememberMe(), isTrue);

      await tokenService.setRememberMe(false);
      expect(tokenService.getRememberMe(), isFalse);
    });
  });

  group('isLoggedIn', () {
    test('is false when Remember Me was never enabled, even with a valid token', () async {
      // Remember Me defaults false — the token check must short-circuit.
      final isLoggedIn = await tokenService.isLoggedIn();
      expect(isLoggedIn, isFalse);
      verifyNever(() => secureStorage.read(key: 'auth_token'));
    });

    test('is true when Remember Me is on and a token exists', () async {
      await tokenService.setRememberMe(true);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => 'jwt-123');

      expect(await tokenService.isLoggedIn(), isTrue);
    });

    test('is false when Remember Me is on but the token was cleared', () async {
      await tokenService.setRememberMe(true);
      when(() => secureStorage.read(key: 'auth_token')).thenAnswer((_) async => null);

      expect(await tokenService.isLoggedIn(), isFalse);
    });
  });

  group('clearSessionIfNotRemembered', () {
    test('wipes the token when Remember Me is off', () async {
      await tokenService.clearSessionIfNotRemembered();

      verify(() => secureStorage.delete(key: 'auth_token')).called(1);
      verify(() => secureStorage.delete(key: 'auth_user_id')).called(1);
    });

    test('leaves the token untouched when Remember Me is on', () async {
      await tokenService.setRememberMe(true);
      await tokenService.clearSessionIfNotRemembered();

      verifyNever(() => secureStorage.delete(key: 'auth_token'));
      verifyNever(() => secureStorage.delete(key: 'auth_user_id'));
    });
  });

  group('clearSession — full logout / forced session expiry', () {
    test('deletes token, user id, and the Remember Me preference', () async {
      await tokenService.setRememberMe(true);

      await tokenService.clearSession();

      verify(() => secureStorage.delete(key: 'auth_token')).called(1);
      verify(() => secureStorage.delete(key: 'auth_user_id')).called(1);
      // Remember Me must not survive a logout/session-expiry, otherwise
      // the next app start would look "logged in" with no token.
      expect(tokenService.getRememberMe(), isFalse);
    });
  });
}
