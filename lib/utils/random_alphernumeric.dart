import 'dart:core';
import 'dart:math';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

String randomString(int strlen) {
  final Random rnd =  Random( DateTime.now().millisecondsSinceEpoch);
  final StringBuffer buffer =  StringBuffer();
  for (var i = 0; i < strlen; i++) {
    buffer.write(chars[rnd.nextInt(chars.length)]);
  }
  return buffer.toString();
}