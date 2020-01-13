import 'dart:convert';

import 'package:kite_bird/configs/jarvis/jarvis_sms_config.dart';
import 'package:http/http.dart' as http;

void jarvisSendSms({String phoneNo, String body})async{
  final _base64E = base64Encode(utf8.encode('$consumerKey:$consumeSecret'));
    final String basicAuth = 'Basic $_base64E';
  
    final Map<String, dynamic> _smsPayload = {
      'phoneNo': phoneNo,
      'message': body
    };
    try {
      await http.post(jarvisSmsUrl, body: json.encode(_smsPayload), headers: <String, String>{'authorization': basicAuth, 'content-type': 'application/json'});
    } catch (e) {
      print(e);
    }
  
}