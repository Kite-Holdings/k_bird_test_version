import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/configs/mpesa/mpesa_configs.dart';
import 'package:kite_bird/third_party_operations/mpesa/fetch_token.dart';
import 'package:kite_bird/utils/stringify_int.dart';


class StkPushQueryRequest{

  StkPushQueryRequest({this.checkoutRequestID});

  final String checkoutRequestID;

  String _businessShortCode;
  String _password;
  String _timestamp;

  Future<Map<String, dynamic>> process() async{    
    final Map<String, dynamic> _tokenRes = await fetchMpesaToken();
    final String accessToken =_tokenRes['body']['token'].toString();
    final now = DateTime.now();
    final String _dt = now.year.toString() + stringifyCount(now.month, 2) + stringifyCount(now.day, 2) + stringifyCount(now.hour, 2) + stringifyCount(now.minute, 2) + stringifyCount(now.second, 2);
    final str = mpesaBusinesShortCode + mpesaPassKey + _dt;
    final bytes = utf8.encode(str);

    _password = base64.encode(bytes);
    _timestamp = _dt;
    _businessShortCode = mpesaBusinesShortCode;

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

