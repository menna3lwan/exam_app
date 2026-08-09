// Validators back every auth form (Login, SignUp, ForgetPassword,
// ResetPassword). These are pure functions with no Flutter dependency,
// so every branch is cheap to cover — and worth covering, since a wrong
// regex here either locks users out or lets bad data reach the API.
import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/common/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('null is invalid', () {
      expect(Validators.required(null), 'This field is required');
    });
    test('empty/whitespace-only is invalid', () {
      expect(Validators.required('   '), isNotNull);
    });
    test('non-empty is valid', () {
      expect(Validators.required('x'), isNull);
    });
    test('uses the custom field name in the message', () {
      expect(Validators.required(null, 'Username'), 'Username is required');
    });
  });

  group('Validators.email', () {
    test('null/empty is invalid', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
    });
    test('missing @ is invalid', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });
    test('missing domain suffix is invalid', () {
      expect(Validators.email('a@b'), isNotNull);
    });
    test('well-formed email is valid', () {
      expect(Validators.email('test@test.com'), isNull);
    });
    test('trims surrounding whitespace before validating', () {
      expect(Validators.email('  test@test.com  '), isNull);
    });
  });

  group('Validators.password — reports the first failing rule', () {
    test('empty is invalid', () {
      expect(Validators.password(''), 'Password is required');
    });
    test('too short is invalid', () {
      expect(Validators.password('Aa1!'), contains('at least 8'));
    });
    test('missing uppercase is invalid', () {
      expect(Validators.password('aa1!aaaa'), contains('upper case'));
    });
    test('missing lowercase is invalid', () {
      expect(Validators.password('AA1!AAAA'), contains('lower case'));
    });
    test('missing digit is invalid', () {
      expect(Validators.password('Aaaa!aaa'), contains('number'));
    });
    test('missing special character is invalid', () {
      expect(Validators.password('Aaaa1aaa'), contains('special character'));
    });
    test('a password satisfying every rule is valid', () {
      expect(Validators.password('Aaaa1!aa'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('empty is invalid', () {
      expect(Validators.confirmPassword('', 'Aaaa1!aa'), isNotNull);
    });
    test('mismatch is invalid', () {
      expect(Validators.confirmPassword('different', 'Aaaa1!aa'), 'Password not matched');
    });
    test('exact match is valid', () {
      expect(Validators.confirmPassword('Aaaa1!aa', 'Aaaa1!aa'), isNull);
    });
  });

  group('Validators.phone (Egyptian numbers)', () {
    test('empty is invalid', () {
      expect(Validators.phone(''), isNotNull);
    });
    test('wrong length is invalid', () {
      expect(Validators.phone('0101234567'), isNotNull); // 10 digits
    });
    test('invalid prefix is invalid', () {
      expect(Validators.phone('01312345678'), isNotNull); // 013 not allowed
    });
    for (final prefix in ['010', '011', '012', '015']) {
      test('valid prefix $prefix with 11 digits is valid', () {
        expect(Validators.phone('${prefix}12345678'), isNull);
      });
    }
  });

  group('Validators.name', () {
    test('empty is invalid', () {
      expect(Validators.name(null), isNotNull);
    });
    test('single character is invalid (min length 2)', () {
      expect(Validators.name('A'), isNotNull);
    });
    test('two or more characters is valid', () {
      expect(Validators.name('Al'), isNull);
    });
  });

  group('Validators.username', () {
    test('empty is invalid', () {
      expect(Validators.username(''), isNotNull);
    });
    test('shorter than 3 characters is invalid', () {
      expect(Validators.username('ab'), isNotNull);
    });
    test('3+ characters is valid', () {
      expect(Validators.username('abc'), isNull);
    });
  });

  group('PasswordRules — granular checks for the live requirements widget', () {
    test('each rule is evaluated independently', () {
      const weak = 'aaaaaaaa';
      expect(PasswordRules.hasMinLength(weak), isTrue);
      expect(PasswordRules.hasUpperCase(weak), isFalse);
      expect(PasswordRules.hasLowerCase(weak), isTrue);
      expect(PasswordRules.hasDigit(weak), isFalse);
      expect(PasswordRules.hasSpecialChar(weak), isFalse);
      expect(PasswordRules.isValid(weak), isFalse);
    });

    test('isValid is true only when every rule passes', () {
      expect(PasswordRules.isValid('Aaaa1!aa'), isTrue);
      expect(PasswordRules.isValid('Aaaa1aa'), isFalse); // no special char, and 7 chars
    });
  });
}
