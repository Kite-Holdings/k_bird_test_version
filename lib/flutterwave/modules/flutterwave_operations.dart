import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/flutterwave/configs/flutterwave_config.dart';
import 'package:kite_bird/flutterwave/utils/flutterwave_utils.dart';

class FlutterWaveCardDeposit{

  FlutterWaveCardDeposit({
    this.cardNo,
    this.cvv,
    this.expiryMonth,
    this.expiryYear,
    this.currency = 'KES',
    this.country = 'KE',
    this.amount,
    this.email,
    this.walletNo,
    this.callbackUrl,
    this.requestId,
  });

  final String cardNo;
  final String cvv;
  final String expiryMonth;
  final String expiryYear;
  final String currency;
  final String country;
  final String amount;
  final String email;
  final String walletNo;
  final String callbackUrl;
  final String requestId;

  final String _publicKey = flutterWavePubKey;
  final String _secretKey = flutterWaveSecurityKey;
  String txRef;
  String redirectUrl = flutterWaveCardredirect;

  Future<Map<String, dynamic>> flutterWaveCardTransact() async{

    txRef = requestId;
    final Map<String, dynamic> _data = {
      "PBFPubKey": _publicKey,
      "cardno": cardNo,
      "cvv": cvv,
      "expirymonth": expiryMonth,
      "expiryyear": expiryYear,
      "currency": currency,
      "country": country,
      "amount": amount,
      "email": email,
      "txRef": txRef,
      "redirect_url": redirectUrl,
    };

    final String _hashedSecKey = getKey(_secretKey);
    final String encrypt3DESKey = encryptData(_hashedSecKey, json.encode(_data));
    final Map<String, dynamic> _payload = {
        "PBFPubKey": _publicKey,
        "client": encrypt3DESKey,
        "alg": "3DES-24"
    };

    const String url = flutterWaveCardUrl;
    final Map<String, String> headers = {
      'content-type': 'application/json',
    };
    
    try {
      final http.Response _flutterWaveRes = await http.post(url, headers: headers, body: json.encode(_payload));
      return {
        "status": 0,
        "body": _flutterWaveRes
      };
    } catch (e) {
      return {
        "status": 1,
        "body": "Could not reach server!"
      };
    }
    
  }


}