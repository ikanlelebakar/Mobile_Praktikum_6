import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('menerima email dengan format valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('nama.lengkap@domain.co.id'), isTrue);
      expect(Validators.isValidEmail('a@b.c'), isTrue);
    });

    test('menolak email tanpa tanda @', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
    });

    test('menolak email tanpa domain bertitik', () {
      expect(Validators.isValidEmail('user@localhost'), isFalse);
      expect(Validators.isValidEmail('user@example'), isFalse);
    });

    test('menolak email tanpa nama pengguna', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
    });

    test('menolak email kosong', () {
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.sanitize', () {
    test('mengganti tag HTML berbahaya dengan entities', () {
      expect(
        Validators.sanitize('<script>alert("xss")</script>'),
        '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;',
      );
    });

    test('mengganti atribut HTML berbahaya', () {
      expect(
        Validators.sanitize('<img src=x onerror=alert(1)>'),
        '&lt;img src=x onerror=alert(1)&gt;',
      );
    });

    test('mengganti kutip tunggal pada atribut', () {
      expect(Validators.sanitize("it's a 'test'"), 'it&#39;s a &#39;test&#39;');
    });

    test('input bersih tidak diubah selain trim', () {
      expect(Validators.sanitize('  teks biasa  '), 'teks biasa');
    });
  });

  group('Validators.validateText', () {
    test('null atau kosong mengembalikan pesan error', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
      expect(Validators.validateText(''), 'Field tidak boleh kosong');
      expect(Validators.validateText('   '), 'Field tidak boleh kosong');
    });

    test('panjang di dalam batas mengembalikan null', () {
      expect(Validators.validateText('a'), isNull);
      expect(Validators.validateText('abc'), isNull);
      expect(
        Validators.validateText('a' * 100, minLength: 1, maxLength: 100),
        isNull,
      );
      expect(
        Validators.validateText('abcde', minLength: 5, maxLength: 10),
        isNull,
      );
    });

    test('terlalu pendek mengembalikan pesan error', () {
      expect(
        Validators.validateText('ab', minLength: 3),
        'Field harus antara 3-100 karakter',
      );
      expect(
        Validators.validateText('a' * 10, minLength: 11),
        'Field harus antara 11-100 karakter',
      );
    });

    test('terlalu panjang mengembalikan pesan error', () {
      expect(
        Validators.validateText('a' * 101),
        'Field harus antara 1-100 karakter',
      );
      expect(
        Validators.validateText('a' * 11, minLength: 5, maxLength: 10),
        'Field harus antara 5-10 karakter',
      );
    });

    test('whitespace dihitung setelah trim', () {
      expect(
        Validators.validateText('  ab  ', minLength: 3),
        'Field harus antara 3-100 karakter',
      );
      expect(Validators.validateText('  abc  ', minLength: 3), isNull);
    });

    test('nama field muncul di pesan error', () {
      expect(
        Validators.validateText(null, fieldName: 'Nama'),
        'Nama tidak boleh kosong',
      );
      expect(
        Validators.validateText('ab', fieldName: 'Deskripsi', minLength: 5),
        'Deskripsi harus antara 5-100 karakter',
      );
    });
  });
}
