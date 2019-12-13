import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/third_party_operations/mpesa/mpesa_settings.dart';
import 'package:kite_bird/utils/stringify_int.dart';

class MpesaOperations{

  Future<Map<String, dynamic>> cb({
    String requestId, 
    String phoneNo, 
    String amount, 
    String callBackUrl,
    String referenceNumber,
    String transactionDesc,
  })async{

    final Map<String, dynamic> _tokenRes = await fetchToken();
    if(_tokenRes['status'] != 0){
      return {
        "status": 3,
        "body": {
          "message": "error fetching token"
        }
      };
    } else {
      final String accessToken = _tokenRes['body']['token'].toString();

      final DateTime _now = DateTime.now();
      final String _dt = _now.year.toString() + stringifyCount(_now.month, 2) + stringifyCount(_now.day, 2) + stringifyCount(_now.hour, 2) + stringifyCount(_now.minute, 2) + stringifyCount(_now.second, 2);
      final String _codeKeyDt = mpesaBusinesShortCode + mpesaPassKey + _dt;
      final List<int> _bytes = utf8.encode(_codeKeyDt);
      final String _password = base64.encode(_bytes);

      final Map<String, dynamic> _payload = {
        "BusinessShortCode": mpesaBusinesShortCode,
        "Password": _password,
        "Timestamp": _dt,
        "TransactionType": "CustomerPayBillOnline",
        "Amount": double.parse(amount),
        "PartyA": phoneNo,
        "PartyB": mpesaBusinesShortCode,
        "PhoneNumber": phoneNo,
        "CallBackURL": '${mpesaCallBackURL}/cb/$requestId',
        "AccountReference": referenceNumber,
        "TransactionDesc": transactionDesc
      };

      print(_payload);


      final Map<String, String> _headers = {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
      };

      try{
        final http.Response _res = await http.post(mpesaCbUrL, headers: _headers, body: json.encode(_payload));
        return {
          "status": 0,
          "body": _res
        };
      } catch (e){
        return {
          "status": 3,
          "body": "cannot reach endpoint"
        };
      }
    }
  }

  Future<Map<String, dynamic>> fetchToken()async{
    const String username = mpesaConsumerKey;
    const String password = mpesaConsumerSecret;
    final _base64E = base64Encode(utf8.encode('$username:$password'));
    final String basicAuth = 'Basic $_base64E';

    try{
      final http.Response _res = await http.get(mpesaTokenUrl,headers: <String, String>{'authorization': basicAuth});
      if(_res.statusCode == 200){
        final _body = json.decode(_res.body);
        return {
          "status": 0,
          "body": {
            "token": _body['access_token'].toString()
          }
        };
      } else {
        return {
          "status": 1,
          "body": {
            "message": json.decode(_res.body)
          }
        };
      }
    }catch (e){
      return {
        "status": 3,
        "body": {
          "message": "cannot reach endpoint"
        }
      };
    }

  }

}