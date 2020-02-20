import 'dart:convert';

import 'package:kite_bird/cellulant/configs/cellulant_configs.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class CellulantPaymentModule{
  CellulantPaymentModule({this.amount, this.accountNumber, this.phoneNo, this.serviceID});

  final String accountNumber;
  final String phoneNo;
  final String amount;
  final int serviceID;

  final DateTime _date = DateTime.now();
  Future<Map<String, dynamic>> pay()async{
    final Map<String, dynamic> response = {};
    final String dateString = _date.toString().substring(0, 19);
    final String payerTransactionID = ObjectId().toJson();
    final Map<String, dynamic> _payload = {
      "function": "BEEP.postPayment",
      "payload": "{\"credentials\":{\"username\":\"$cellulantUsername\",\"password\":\"$cellulantPassword\"},\"packet\": [{\"MSISDN\":\"$phoneNo\",\"amount\":\"$amount\",\"serviceID\":$serviceID,\"currencyCode\":\"KES\",\"narration\":\"Paydstv\",\"accountNumber\":\"$accountNumber\",\"extraData\":\"\",\"datePaymentReceived\":\"$dateString\",\"payerTransactionID\":\"$payerTransactionID\",\"customerNames\":\"SimonMathenge\"}]}"
    };
    try {
      final http.Response _res = await http.post(cellulantPaymentnUrl, body: json.encode(_payload));
      final dynamic _body = json.decode(_res.body);
      if(_res.statusCode == 200){
        if(_body['authStatus']['authStatusCode'] == 131){
          
          if(_body['results'][0]['statusCode'] == 139){
            response['status'] = 0;
            response['body'] = _body['results'][0];
          } else {
            response['status'] = 101;
            response['body'] = _body['results'][0];
          }

        } else {
          response['status'] = 102;
          response['body'] = 'An error occured !';
        }
      } else {
        response['status'] = 2;
        response['body'] = _body;
      }
    } catch (e) {
      print(e);
      response['status'] = 102;
      response['body'] = 'Time out';
    }

    return response;
    
  }

  

}