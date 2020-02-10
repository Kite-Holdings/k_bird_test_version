import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:tripledes/tripledes.dart';

String getKey(String secKey){
  final String _hashedseckey =  md5.convert(utf8.encode(secKey)).toString();
  final String _hashedseckeylast12 = _hashedseckey.substring(_hashedseckey.length -12, _hashedseckey.length);
  final String _seckeyadjusted = secKey.split('FLWSECK-').last;
  final String _seckeyadjustedfirst12 = _seckeyadjusted.substring(0, 12);
  return _seckeyadjustedfirst12 + _hashedseckeylast12;
}

String encryptData(String key, String plainText){
  final BlockCipher _blockCipher = BlockCipher(TripleDESEngine(), key);
  final String _ciphertext = _blockCipher.encodeB64(plainText);
  return _ciphertext;
}
