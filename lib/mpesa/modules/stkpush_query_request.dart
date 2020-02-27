import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateMpesaCbModel;
import 'package:kite_bird/cooprates/modules/cooprates_modules.dart' show CooprateAccountConfModule;
import 'package:kite_bird/mpesa/configs/mpesa_config.dart';
import 'package:kite_bird/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;
import 'package:kite_bird/utils/stringify_int.dart';


class StkPushQueryRequest{

  StkPushQueryRequest({this.checkoutRequestID, this.cooprateCode});

  final String checkoutRequestID;
  final String cooprateCode;

  String _businessShortCode;
  String _password;
  String _timestamp;

  Future<Map<String, dynamic>> process() async{    
    // fetch configs
    final CooprateAccountConfModule _accountConfModule = CooprateAccountConfModule(cooprateCode: cooprateCode);
    final CooprateMpesaCbModel _conf = await _accountConfModule.mpesaCbConf();

    final String _passKey = _conf.passKey;
    final String _key = _conf.consumerKey;
    final String _secret = _conf.consumerSecret;
    final String _shortCode = _conf.shortCode;


    final Map<String, dynamic> _tokenRes = await fetchMpesaToken(key: _key, secret: _secret);
    final String accessToken =_tokenRes['body']['token'].toString();
    final now = DateTime.now();
    final String _dt = now.year.toString() + stringifyCount(now.month, 2) + stringifyCount(now.day, 2) + stringifyCount(now.hour, 2) + stringifyCount(now.minute, 2) + stringifyCount(now.second, 2);
    final str = _shortCode + _key + _dt;
    final bytes = utf8.encode(str);

    _password = base64.encode(bytes);
    _timestamp = _dt;
    _businessShortCode = _shortCode;

    final Map<String, String> _payload = {
      "BusinessShortCode": _businessShortCode,
      "Password": _password,
      "Timestamp": _timestamp,
      "CheckoutRequestID": checkoutRequestID
    };

    final Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    const String url = mpesaStkPushQueryRequestUrl;
    
    Map<String, dynamic> _message;
    try{
      final http.Response r = await http.post(url, headers: headers, body: json.encode(_payload));
      if(r.statusCode == 200){
        _message = {
          'status': 0,
          'resultCode': json.decode(r.body)['ResultCode'],
          'body': json.decode(r.body)
        };
      } else {
        _message = {
          'status': 1,
          'body': json.decode(r.body)
        };
      }
    } catch (e){
      _message = {
        'status': 101,
        'body': e
      };
    }

    return _message;

  }
}

