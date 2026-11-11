import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators Test Suite', () {
    // a) Test isValidEmail() dengan berbagai skenario
    group('isValidEmail()', () {
      test('mengembalikan true untuk format email yang valid', () {
        expect(Validators.isValidEmail('mahasiswa@amikom.ac.id'), isTrue);
        expect(Validators.isValidEmail('user.name@example.com'), isTrue);
        expect(Validators.isValidEmail('test+alias@domain.org'), isTrue);
      });

      test('mengembalikan false untuk format email yang tidak valid', () {
        expect(Validators.isValidEmail('mahasiswaamikom.ac.id'), isFalse);
        expect(Validators.isValidEmail('user@'), isFalse);
        expect(Validators.isValidEmail('@domain.com'), isFalse);
        expect(Validators.isValidEmail('user@domain'), isFalse);
      });

      test('mengembalikan false untuk string kosong atau null', () {
        expect(Validators.isValidEmail(''), isFalse);
        expect(Validators.isValidEmail('   '), isFalse);
        expect(Validators.isValidEmail(null), isFalse);
      });
    });

    // b) Test sanitize() dengan input berbahaya
    group('sanitize()', () {
      test('menetralkan tag HTML berbahaya (<script>)', () {
        const malicious = '<script>alert("XSS")</script>';
        final result = Validators.sanitize(malicious);
        expect(result, isNot(contains('<script>')));
        expect(result, contains('&lt;script&gt;'));
      });

      test('menetralkan karakter tanda petik dan simbol injection', () {
        const input = "admin' OR '1'='1' -- & \"test\"";
        final result = Validators.sanitize(input);
        expect(result, isNot(contains("'")));
        expect(result, isNot(contains('"')));
        expect(result, contains('&#x27;'));
        expect(result, contains('&quot;'));
        expect(result, contains('&amp;'));
      });
    });

    // c) Test validateText() dengan berbagai panjang
    group('validateText()', () {
      test('mengembalikan null jika panjang teks sesuai rentang yang diizinkan', () {
        final result = Validators.validateText('Halo Dunia', minLength: 3, maxLength: 20);
        expect(result, isNull);
      });

      test('mengembalikan pesan error jika teks kosong atau null', () {
        expect(Validators.validateText(''), equals('Teks tidak boleh kosong'));
        expect(Validators.validateText(null), equals('Teks tidak boleh kosong'));
      });

      test('mengembalikan pesan error jika teks kurang dari minLength', () {
        final result = Validators.validateText('Hi', minLength: 3, maxLength: 20);
        expect(result, equals('Panjang minimal 3 karakter'));
      });

      test('mengembalikan pesan error jika teks melebihi maxLength', () {
        final result = Validators.validateText('Teks ini sangat panjang sekali', minLength: 3, maxLength: 10);
        expect(result, equals('Panjang maksimal 10 karakter'));
      });
    });
  });
}