import 'package:encrypt/encrypt.dart';

String encrypt(String password) {
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(password, iv: iv);

  return encrypted.base64;
}
