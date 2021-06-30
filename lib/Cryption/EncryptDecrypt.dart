import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
 class MyEncryption{
 static final _key=encrypt.Key.fromLength(32);
 static final _iv=encrypt.IV.fromLength(16);
 static final _encrypter=encrypt.Encrypter(encrypt.AES(_key));
 static encyption(text){
   final encrypted=_encrypter.encrypt(text,iv:_iv);
   ("ENCRYPTION "+encrypted.bytes.toString());
   return encrypted.base64;
 }
 static decryption(text){
  

   final decrypted=_encrypter.decrypt(encrypt.Encrypted.from64(text),iv:_iv);
   return decrypted;
 }
 }