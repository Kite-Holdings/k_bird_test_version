import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateCardModel;
import 'package:kite_bird/cooprates/modules/cooprates_modules.dart' show CooprateAccountConfModule;
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
    // this.walletNo,
    this.cooprateCode,
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
  // final String walletNo;
  final String cooprateCode;
  final String callbackUrl;
  final String requestId;

  String txRef;
  String redirectUrl = flutterWaveCardredirect;

  Future<Map<String, dynamic>> flutterWaveCardTransact() async{

    // fetch configs
    final CooprateAccountConfModule _accountConfModule = CooprateAccountConfModule(cooprateCode: cooprateCode);
    final CooprateCardModel _conf = await _accountConfModule.cardConf();

    final String _key = _conf.consumerKey;
    final String _secret = _conf.consumerSecret;

    txRef = requestId;
    final Map<String, dynamic> _data = {
      "PBFPubKey": _key,
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

    final String _hashedSecKey = getKey(_secret);
    final String encrypt3DESKey = encryptData(_hashedSecKey, json.encode(_data));
    final Map<String, dynamic> _payload = {
        "PBFPubKey": _key,
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