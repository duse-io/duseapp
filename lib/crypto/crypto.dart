library duseapp.crypto.crypto;

import 'dart:html' show window;
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List;

import 'package:crypto/crypto.dart' show CryptoUtils, MD5;
import 'package:cipher/cipher.dart';
import 'package:cipher/impl/client.dart';

String buildGravatarHash(String mail) {
  mail = mail.trim().toLowerCase();
  var md5 = new MD5();
  md5.add(mail.codeUnits);
  return md5.close().map(byteToHex)
                    .reduce((s1, s2) => s1 + s2)
                    .toLowerCase();
}

String byteToHex(int byte) {
  if (byte < 0 || byte > 255) throw new RangeError.range(byte, 0, 255);
  return byte.toRadixString(16).padLeft(2, "0");
}

Uint8List _s2osp(String str, [int length]) {
  if (null == length) length = str.length;
  var codeUnits = str.codeUnits;
  if (codeUnits.length > length) throw new ArgumentError.value(str);
  return new Uint8List.fromList([]
    ..addAll(codeUnits)
    ..addAll(new List.filled(length - codeUnits.length, 0)));
}

String _os2sp(List<int> os) {
  var end = os.indexOf(-1);
  var codeUnits = end != -1 ? os.sublist(0, end) : os;
  return new String.fromCharCodes(codeUnits);
}

String encryptAndStore(String key, String password, String content) {
  _initialize();
  
  var keyParam = new KeyParameter(_s2osp(password, 32));
  var aes = new BlockCipher("AES")
    ..init(true, keyParam);
  
  var blocks = _divideIntoBlocks(_s2osp(content), 16);
  var cipherBytes = blocks.map(aes.process).fold([], (l1, l2) => l1..addAll(l2));
  var cipher = CryptoUtils.bytesToBase64(cipherBytes, urlSafe: true);
  
  window.localStorage[key] = cipher;
  return cipher;
}

String retrieveAndDecrypt(String key, String password) {
  _initialize();
  
  var cipher = window.localStorage[key];
  var cipherBytes = _divideIntoBlocks(new Uint8List.fromList(
      CryptoUtils.base64StringToBytes(cipher)), 16);
  
  var keyParam = new KeyParameter(_s2osp(password, 32));
  var aes = new BlockCipher("AES")
    ..init(false, keyParam);
  
  var plainBytes = cipherBytes.map(aes.process).fold([], (l1, l2) => l1..addAll(l2));
  return _os2sp(plainBytes);
}

List<Uint8List> _divideIntoBlocks(Uint8List source, int blockLength) {
  var result = [];
  int i = 0;
  while (i < source.length) {
    i += blockLength;
    var end = min(i, source.length);
    result.add(_sizedList(source.sublist(i - blockLength, end), blockLength));
  }
  return result;
}

Uint8List _sizedList(List<int> input, int length) {
  if (input.length > length) throw new ArgumentError.value(input);
  return new Uint8List.fromList([]
    ..addAll(input)
    ..addAll(new List.filled(length - input.length, 0)));
}


bool _wasInitialized = false;
_initialize() {
  if (!_wasInitialized) initCipher();
}