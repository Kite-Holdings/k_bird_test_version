import 'dart:convert';

import 'package:kite_bird/cellulant/configs/cellulant_configs.dart';
import 'package:http/http.dart' as http;

class CellulantValidationModule{
  CellulantValidationModule({this.accountNumber, this.serviceID});

  final String accountNumber;
  final int serviceID;
  Future<Map<String, dynamic>> validate()async{
    final Map<String, dynamic> response = {};
    final Map<String, dynamic> _payload = {
      "function": "BEEP.validateAccount",
      "payload": "{\"credentials\":{\"username\":\"$cellulantUsername\",\"password\":\"$cellulantPassword\"},\"packet\": [{\"serviceID\":$serviceID,\"accountNumber\":\"$accountNumber\",\"requestExtraData\":\"\"}]}"
    };
    try {
      final http.Response _res = await http.post(cellulantValidationUrl, body: json.encode(_payload));
      final dynamic _body = json.decode(_res.body);
      if(_res.statusCode == 200){
        if(_body['authStatus']['authStatusCode'] == 131){
          
          if(_body['results'][0]['statusCode'] == 307){
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