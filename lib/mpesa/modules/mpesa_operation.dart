import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kite_bird/cooprates/models/cooprates_models.dart' show CooprateMpesaBcModel;
import 'package:kite_bird/cooprates/modules/cooprates_modules.dart' show CooprateAccountConfModule;
import 'package:kite_bird/mpesa/configs/mpesa_config.dart';
import 'package:kite_bird/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;
import 'package:kite_bird/utils/stringify_int.dart';

class MpesaOperations{

  Future<Map<String, dynamic>> cb({
    String requestId, 
    String phoneNo, 
    String amount, 
    String walletNo,
    String transactionDesc,
  })async{

    final Map<String, dynamic> _tokenRes = await fetchMpesaToken();
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
        "CallBackURL": '$mpesaCallBackURL/cb/$requestId',
        "AccountReference": walletNo,
        "TransactionDesc": transactionDesc
      };



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

  Future<Map<String, dynamic>> bc({
    String cooprateCode, 
    String requestId, 
    String phoneNo, 
    String amount, 
    String transactionDesc,
  })async{
    final CooprateAccountConfModule _accountConfModule = CooprateAccountConfModule(cooprateCode: cooprateCode);
    final CooprateMpesaBcModel _conf = await _accountConfModule.mpesaBcConf();

    final String initiatorName = _conf.initiatorName;
    final String securityCredential = _conf.securityCredential;
    final String _key = _conf.consumerKey;
    final String _secret = _conf.consumerSecret;
    final String _shortCode = _conf.shortCode;

    final Map<String, dynamic> _tokenRes = await fetchMpesaToken(key: _key, secret: _secret);
    if(_tokenRes['status'] != 0){
      return {
        "status": 3,
        "body": {
          "message": "error fetching token"
        }
      };
    } else {
      final String accessToken = _tokenRes['body']['token'].toString();

    final Map<String, dynamic> _payload = {
      "InitiatorName": initiatorName,
      "SecurityCredential": securityCredential,
      "CommandID": "BusinessPayment",
      "Amount": amount,
      "PartyA": _shortCode,
      "PartyB": phoneNo,
      "Remarks": transactionDesc,
      "QueueTimeOutURL": '$mpesaCallBackURL/bc/$requestId',
      "ResultURL": '$mpesaCallBackURL/bc/$requestId',
      "AccountReference": requestId
  };



      final Map<String, String> _headers = {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
      };

      try{
        final http.Response _res = await http.post(mpesaBcUrL, headers: _headers, body: json.encode(_payload));
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

  


}